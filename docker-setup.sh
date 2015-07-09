#!/bin/bash
# Setup docker  & docker registry for CCC cluster

echo "Docker setup 1.0"
[ -z "$HTTP_PROXY" ] && echo "Error. You need to export HTTP_PROXY" && exit 1;
[ -z "$docker_registry_ip" ] && echo "Error. You need to export docker_registry_ip" && exit 1;



 
export work_dir=/tmp
export docker_root=/mnt/app_hdd/docker
export docker_registry_install=/opt/docker-registry
export docker_registry_images=/cluster_share/scratch/docker-registry-images
#export docker_registry_ip=192.168.1.240
export NO_PROXY=127.0.0.1,localhost,ccc.docker
export no_proxy=$NO_PROXY

echo "Using:"
echo "docker_registry_ip=$docker_registry_ip"
echo "docker_root=$docker_root"
echo "docker_registry_ip=$docker_registry_ip"
echo "work_dir=$work_dir"
echo "docker_registry_images=$docker_registry_images"


cd $work_dir

## install docker daemon
curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.6.2
chmod +x docker-1.6.2
sudo mv docker-1.6.2 /usr/bin/docker
sudo chown root:root /usr/bin/docker

# configure docker daemon, uses $http_proxy from caller
cat <<EOT  >> /etc/sysconfig/docker
HTTP_PROXY=$http_proxy
http_proxy=\$HTTP_PROXY
HTTPS_PROXY=\$HTTP_PROXY
https_proxy=\$HTTP_PROXY
NO_PROXY=ccc.docker
no_proxy=\$NO_PROXY
export HTTP_PROXY HTTPS_PROXY http_proxy https_proxy no_proxy NO_PROXY
other_args="-g=$docker_root --insecure-registry ccc.docker"
EOT

service docker stop
service docker start

# if this is a compute node, set alias and exit
if [ "`hostname -i`" != "$docker_registry_ip" ]    ; then 
# create alias of ccc.docker
cat <<EOT >> /etc/hosts
$docker_registry_ip   ccc.docker
EOT
  echo "Compute node docker setup finished";
  docker info   
  exit 0
else 
  echo "Registry node, docker setup finished"  ; 
  echo "Registry node, docker-registry setup starting..."  ; 
fi



## install docker-registry 
curl -L https://github.com/docker/distribution/archive/v2.0.0.tar.gz | sudo tar xz
mv distribution-2.0.0 $docker_registry_install

# create certs for docker-registry
cd $docker_registry_install
mkdir certs
 
cat <<EOT | openssl req -newkey rsa:2048 -nodes -keyout certs/domain.key  -x509 -days 365 -out certs/domain.crt
US
OR
Hillsboro
Intel
CCC
`hostname`
admin@`hostname`.intel.com
EOT

# build the image
sudo docker build -t registry .

# create the directory that will hold registry images
cd $work_dir
mkdir $docker_registry_images

# start the registry, uses $docker_registry_images from caller
docker run -d -v $docker_registry_images:/tmp/registry-dev -p 5000:5000 registry:latest

# we should be able to talk to it
if curl  http://localhost:5000/v2/ | grep {} ; then
    echo "Ping of docker-registry at local host   worked."
else
    echo "ERROR Ping of docker-registry at local host failed."
    exit 1
fi

# create alias of ccc.docker
cat <<EOT >> /etc/hosts
127.0.0.1   ccc.docker
EOT

if curl  --noproxy '*' http://ccc.docker:5000/v2/ | grep {} ; then
    echo "Ping of docker-registry at ccc.docker  worked."
else
    echo "ERROR Ping of docker-registry  at ccc.docker failed."
    exit 1
fi

# create a script to launch the registry on restart 
cat <<EOT > /etc/init.d/registry
#!/bin/sh
# chkconfig:   2345 96 94

### BEGIN INIT INFO
# Provides:          Manage Docker registry service
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start: 2 3 4 5
# Default-Stop:  0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

image="registry:latest"
host_image_dir="$docker_registry_images"
container_image_dir="/tmp/registry-dev"
from_port="5000"
to_port="5000"

name=`basename \$0`

cmd="docker run -d -v \$host_image_dir:\$container_image_dir -p \$from_port:\$to_port \$image"

get_container() {
  if [ -n "\$(docker ps -q)" ]; then
    docker ps -q | xargs docker inspect --format '{{.Id}} {{.Config.Image}}' | grep \$image | cut -f 1 -d ' '
  fi
}

is_running() {
  if [ -n "\$(get_container)" ]; then
    return 0
  else
    return 1
  fi
}

case "\$1" in
    start)
    if is_running; then
        echo "Already started"
    else
        \$cmd > /dev/null

        sleep 1

        if ! is_running; then
            echo "Unable to start, see \$stdout_log and \$stderr_log"
            exit 1
        fi
    fi
    ;;
    stop)
    if is_running; then
        echo -n "Stopping \$name instance..."
        docker stop \$(get_container)
        for i in {1..10}
        do
            if ! is_running; then
                break
            fi

            echo -n "."
            sleep 1
        done
        echo

        if is_running; then
            echo "Unable to stop. Trying to kill container."
            docker kill \$(get_container)

            for i in {1..10}
            do
                if ! is_running; then
                    break
                fi

                echo -n "."
                sleep 1
            done

            if is_running; then
              echo "Unable to stop or kill container. Aborting!"
              exit 1
            else
              echo "Killed"
            fi
        else
            echo "Stopped"
        fi
    else
        echo "Not running"
    fi
    ;;
    restart)
    \$0 stop
    if is_running; then
        echo "Unable to stop, will not attempt to start"
        exit 1
    fi
    \$0 start
    ;;
    status)
    if is_running; then
        echo "Running"
    else
        echo "Stopped"
        exit 1
    fi
    ;;
    *)
    echo "Usage: \$0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
EOT

chmod a+x /etc/init.d/registry
chmod 755 /etc/init.d/registry
chkconfig registry on



cat <<EOT  >>  /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/x86_64/
gpgcheck=0
enabled=1
EOT

yum install nginx


if nginx -v 2>&1 >/dev/null  | grep 1.8.0  ; then
    echo "install of nginx 1.8 worked."
else
    echo "ERROR install of nginx 1.8 failed."
fi


cat <<EOT  >> /etc/nginx/conf.d/default.conf
server 
{
    listen      80 default ;
    listen      443 ssl;
    server_name galaxy ccc.docker;
    access_log  /tmp/nginx_reverse_access.log;
    error_log   /tmp/nginx_reverse_error.log;
    root        /usr/local/nginx/html;
    index       index.html;
    dav_methods  PUT DELETE MKCOL COPY MOVE;

    client_max_body_size 0; # disable any limits to avoid HTTP 413 for large image uploads

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  10m;
    ssl_certificate $docker_registry_install/certs/domain.crt;
    ssl_certificate_key $docker_registry_install/certs/domain.key;
    ssl_verify_client off;
    ssl_protocols        SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers RC4:HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

   location /
   {
        proxy_pass  http://localhost:5000;
    }
}
EOT

service nginx restart



if curl -k https://ccc.docker/v2/ | grep {} ; then
    echo "Ping of docker registry via nginx worked"
else
    echo "Ping of docker registry via nginx failed"
    exit 1
fi

docker info   
exit 0

