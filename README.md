## Dockerized Tool Installation Checklist ##

*Note: the following instructions have been validated with a CentOS 6.6 virtual machine*

### Overview ###

This document outlines the installation of Docker clients (v1.6), a Docker registry (v2.0), approaches on updating Nginx configurations, and testing methodologies for verifying Dockerized tools work in Galaxy.   

### Installing Docker on compute and gateway nodes ###

0. **Prework: Verify centos version**  
    ```
    $ cat /etc/centos-release 
    CentOS release 6.6 (Final)
    
    $ uname -r
    2.6.32-504.16.2.el6.x86_64
    ```
    _NOTE_: kernel version 2.6.32-431.5.1.el6.x86_64 _is not stable with docker (kernel panics)_
    If you do need to update the kernel
    ```bash
    >sudo yum clean all
    >sudo vi /etc/yum/pluginconf.d/priorities.conf
     # change enabled = 1 to enabled = 0
    >sudo http_proxy=http://sparkdmz1.spark0.intel.com:2000 yum update "kernel-*"
    ```
1. **Enable EPEL Yum repository.** This allows us to install Docker 1.5.

    ```bash
    > sudo yum install epel-release
    ```

2. **Install Docker 1.5.**

    ```bash
    > sudo yum install docker-io
    ```

3. **Upgade the Docker binary to version 1.6.**

    Note that we can install version 1.5 via the repositories, but we're going to want to upgrade to version 1.6 so that we can take advantage of the new Docker Registry architecture.

    ```bash
    > curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.6.2
    > chmod +x docker-1.6.2
    > sudo mv docker-1.6.2 /usr/bin/docker
    > sudo chown root:root /usr/bin/docker
    ```
    
    Why are we doing this? We can use the same services that come with the
    1.5 distribution (i.e., `service docker start` and `chkconfig`) with
    the 1.6 binary.
    
0. **Ensure that the process running docker has appropriate proxy settings**
  ```bash
  # /etc/sysconfig/docker
  #
  # Other arguments to pass to the docker daemon process
  # These will be parsed by the sysv initscript and appended
  # to the arguments list passed to docker -d
  HTTP_PROXY=http://sparkdmz1.spark0.intel.com:2000
  http_proxy=$HTTP_PROXY
  HTTPS_PROXY=$HTTP_PROXY
  https_proxy=$HTTP_PROXY
  NO_PROXY=ccc.docker
  no_proxy=$NO_PROXY
  export HTTP_PROXY HTTPS_PROXY http_proxy https_proxy no_proxy NO_PROXY
  other_args="-g=/mnt/app_hdd/docker --insecure-registry ccc.docker"
  ```




4. **Start the Docker daemon and make sure it starts on boot.**

    ```bash
    > sudo service docker start
    Starting cgconfig service:                [  OK  ]
    Starting docker:                          [  OK  ]
    > sudo chkconfig docker on
    ```
    
    I've tested this with restarting the VM to ensure that the Docker daemon is running.
    _//Depending on base configuration, you may not see "Starting cgconfig service"_

5. **Verify install.**

    ```bash
    > sudo docker version
    Client version: 1.6.2
    Client API version: 1.18
    Go version (client): go1.4.2
    Git commit (client): 7c8fca2
    OS/Arch (client): linux/amd64
    Server version: 1.6.2
    Server API version: 1.18
    Go version (server): go1.4.2
    Git commit (server): 7c8fca2
    OS/Arch (server): linux/amd64
    ```

    ```bash
    $ sudo docker info
    Containers: 74
    Images: 157
    Storage Driver: devicemapper
     Pool Name: docker-0:18-17-pool
     Pool Blocksize: 65.54 kB
     Backing Filesystem: zfs
     Data file: /dev/loop0
     Metadata file: /dev/loop1
     Data Space Used: 6.628 GB
     Data Space Total: 107.4 GB
     Data Space Available: 100.7 GB
     Metadata Space Used: 14.49 MB
     Metadata Space Total: 2.147 GB
     Metadata Space Available: 2.133 GB
     Udev Sync Supported: false
     Data loop file: /mnt/app_hdd/docker/devicemapper/devicemapper/data
     Metadata loop file: /mnt/app_hdd/docker/devicemapper/devicemapper/metadata
     Library Version: 1.02.82-git (2013-10-04)
    Execution Driver: native-0.2
    Kernel Version: 2.6.32-504.16.2.el6.x86_64
    Operating System: <unknown>
    CPUs: 24
    Total Memory: 125.9 GiB
    Name: v22
    ID: RSKZ:V7BB:KEVA:6WP5:MTEC:PKIR:O5PZ:WFL2:7QJX:NPPK:YN5G:RGMG
    Http Proxy: http://sparkdmz1.spark0.intel.com:2000
    Https Proxy: http://sparkdmz1.spark0.intel.com:2000
    No Proxy: ccc.docker
```

### Installing Docker Registry on gateway node. ###

Note that there is a "development" image available where one can set up a registry pretty quickly with `docker pull registry`. For production purposes, they recommend that you build your own:

> Docker's public registry maintains a default registry image to assist you in the deployment process. This registry image is sufficient for running local tests but is insufficient for production. For production you should configure and build your own custom registry image from the docker/distribution code.

We're going to build our own.

1. **Download the 2.0 release of the Docker Registry.**

    The new and improved registry is a Docker image that we will build ourselves. First by downloading the registry distribution:

> **Note:  due to a 'sweeper' that restores /opt on all machines in the cluster we have installed docker registry in /mnt/app_hdd/scratch/docker-registry  &  /mnt/app_hdd/scratch/docker-registry-images.  In this document, we've maintained the use of the /opt directory, assuming that we will modify the sweeper to maintain these directories**
    
    ```bash
    > cd /opt
    > curl -L https://github.com/docker/distribution/archive/v2.0.0.tar.gz | sudo tar xz
    > sudo mv distribution-2.0.0 docker-registry
    ```
    
2. **Build our private registry**.

    Following the [official documentation](https://docs.docker.com/registry/deploying/#configure-tls-on-a-registry-server) for setting up a registry, let's jump to our registry location:
    
    ```bash
    > cd /opt/docker-registry
    ```
    
    Make a directory to store our certs.
    
    ```bash
    > sudo mkdir certs
    ```

    Create our SSL certificates.
    
    ```bash
    > sudo openssl req \
         -newkey rsa:2048 -nodes -keyout certs/domain.key \
         -x509 -days 365 -out certs/domain.crt
    ```
    
    > *Note*: If you want to use non-self-signed certs, place them in `certs/` prior to building the image.
    
    Following the directions for setting up the self-signed cert.
    
    Run `sudo vim cmd/registry/config.yml` and update the `http` section to be:
    
    ```yaml
    http:
        addr: :5000
        secret: asecretforlocaldevelopment
        debug:
                addr: localhost:5001
        tls:
            certificate: /go/src/github.com/docker/distribution/certs/domain.crt
            key: /go/src/github.com/docker/distribution/certs/domain.key
    ```
    
    > *Note*: We may want to revisit this configuration in the future. It has [nifty options](https://github.com/docker/distribution/blob/v2.0.1/docs/configuration.md) for using Redis, better loggin solutions, notifications, etc.

    Build the image:
    
    ```bash
    > sudo docker build -t registry .
    ```
    
    > *Note*: Do **NOT** push this image up to the registry: it contains the self-signed certs that we just created.
    
    Make a directory (on the host system) where we're going to store images. We'll be mounting this when we run the registry.
    
    ```bash
    > sudo mkdir /opt/docker-registry-images
    ```
    
    Run the image in the background:
    
    ```bash
    > sudo docker run -d -v /opt/docker-registry-images:/tmp/registry-dev -p 5000:5000 registry:latest
    ```

    We should be able to hit the `/V2/` API endpoint:
    
    ```bash
    > curl -k https://localhost:5000/v2/
    {}
    ```
    
    _//_
    
    
    We should be able to hit the `/V2/` API endpoint using the ccc alias:
    
    ```bash
    $ cat /etc/hosts
    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
    127.0.0.1   ccc.docker
    ```
    Note that ccc.docker points to localhost on the _docker registry_ host.  On the _docker client_ hosts, the ccc.docker alias will point to the static IP address of the docker registry host.
    
    ```bash
    > curl -k https://ccc.docker:5000/v2/
    {}
    ```
    
    We can even take a public image, like `ubuntu` and push it to our private registry. Note that we have to re-tag an image that's built with the registry location then push it.
    
    ```bash
    > sudo docker pull ubuntu
    > sudo docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    registry            latest              c63473db2ed9        11 minutes ago      545.8 MB
    golang              1.4                 ca0f230b927e        2 weeks ago         517.2 MB
    ubuntu              latest              07f8e8c5e660        2 weeks ago         188.3 MB
    > sudo docker tag ubuntu:latest ccc.docker/ubuntu
    > sudo docker push ccc.docker/ubuntu
    ```
    
    We can verify that the image is on the private registry:
    
    ```bash
    > curl -k https://ccc.docker/v2/ubuntu/tags/list
    {"name":"ubuntu","tags":["latest"]}
    ```
    
    You'll also notice that since we mounted a volume from the host system to the container to store images, we'll have our images stored in `/opt/docker-registry-images`:
    
    ```bash
    > ls /opt/docker-registry-images/docker/registry/v2/repositories
ubuntu
    ```
    
    K! We have the private registry set up! Just a few more steps...

3. **Configuring the registry to run as a service.**

    At this point, we can stop our Registry container (`docker stop XXX`, where XXX is the container ID from `docker ps`.)
    
    ```bash
    $ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                    NAMES
bb255fffbad7        registry:latest     "registry cmd/regist   19 hours ago        Up 19 hours         0.0.0.0:5000->5000/tcp   mad_torvalds    
    $docker stop  bb255fffbad7
    ```
    

    Here is a [sample init.d](https://gist.github.com/slnovak/e82ace6b5f323da4cdb5) script that allows us to start and stop the registry as a service. To install:
    
    ```bash
    > sudo curl https://gist.githubusercontent.com/slnovak/e82ace6b5f323da4cdb5/raw/33bd8d6a3efa76a7f5845b79c6830aa75b995931/registry > /etc/init.d/registry
    > sudo chmod a+x /etc/init.d/registry
    > sudo chmod 755 /etc/init.d/registry
    ```
    Note: Per the note regarding 'sweeper' above, this script was modified to point to /mnt/app_hdd/scratch instead of /opt
    **host_image_dir="/mnt/app_hdd/scratch/docker-registry-images"**
    
    After that, ensure that the registry gets started at boot:
    
    ```bash
    > sudo chkconfig registry on
    ```
    
    (Note that in that startup script, we're loading it *after* the Docker init script and unloading *before* when shutting down.)
    

4. **Update `/etc/hosts` on compute nodes so they can access the gateway node under a common network name.**

    This is a pretty cruicial step. Since we tag images based on the network location of the private registry, that same network name is going to be used in the Galaxy tool configuration.

    _// note that since hosts within the node have static ip addresses, we can leverage aliases in /etc/hosts with confidence_
    ```bash
    $ cat /etc/hosts
    127.0.0.1	localhost.localdomain	localhost.localdomain	localhost4	localhost4.localdomain4	localhost
    ::1	localhost.localdomain	localhost.localdomain	localhost6	localhost6.localdomain6	localhost
    192.168.100.126 ccc.docker
    ```
    
    ```bash
    $ curl -k https://ccc.docker:5000/v2/
    {}
    ```
    Note: the https_proxy should **`not`** be set
    
    I recommend the alias **`ccc.docker`**. Why? When a user creates a Galaxy tool and creates their .xml file, if they're specifying a Docker container, they'll need to include the domain and port information. It'd be easiest if we could do something along the lines of:
    
    ```xml
    <tool id="smalt_wrapper (docker)" name="SMALT" version="0.0.3">
      <requirements>
    	<container type="docker">ccc.docker/smalt-galaxy/latest</container>
      </requirements>
      <description>maps query reads onto the reference sequences</description>
      <command>
        smalt_wrapper.py 
          --threads="4"
    ```
    
    Note: `ccc.docker/smalt-galaxy/latest`. This assumes that the registry is available at https://ccc.docker:443/v2/...). If we have a clumsy name like `ccc_gateway_node` and we're running the registry on a non-standard port, all Galaxy tool .xml configurations would have to use a container configuration to match that network config, like `ccc_gateway_node:5000/smalt-galaxy/latest`.
    
    Since docker has internal rules that take the name of the registry and transform it into a host and port, it is necessary to have the form of XXX**`.`**YYY. 

5. **Configure Nginx configuration to act as a reverse proxy traffic to Registry container for SSL traffic.**

    Given that the above is running, we need to update our Nginx configuration so that we can proxy SSL connections from the host to the container. The trick here, I think, is to use the option for `proxy_ssl_session_reuse`:
    
    > Determines whether SSL sessions can be reused when working with the proxied server. If the errors â€œSSL3_GET_FINISHED:digest check failedâ€ appear in the logs, try disabling session reuse.
    
    Note Please ensure **`ngix 1.8`** or greater is used
    
    Verify nginx started at reboot
    ```sudo chkconfig nginx on```
    
    The Nginx configuration in /etc/nginx/conf.d/virtual.conf that was used was:
    ```
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
        ssl_certificate /mnt/app_hdd/scratch/docker-registry/certs/domain.crt;
        ssl_certificate_key /mnt/app_hdd/scratch/docker-registry/certs/domain.key;
        ssl_verify_client off;
        ssl_protocols        SSLv3 TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers RC4:HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
    
       location /
       {
            proxy_pass  http://localhost:5000;
        }
    }
    ```
    
    _//When complete this can be tested on both the registry and compute hosts with:_
    ```bash
    $ curl -k https://ccc.docker/v2/
    {}
    ```
    
    Note:  If you see ssl errors at this point, check your environment's proxy settings:
    ```bash
    $  curl -k https://ccc.docker/v2/
    curl: (35) SSL connect error
    
    $  curl -v -k https://ccc.docker/v2/
    * About to connect() to proxy sparkdmz1.spark0.intel.com port 2000 (#0)
    *   Trying 192.168.100.1... connected
    * Connected to sparkdmz1.spark0.intel.com (192.168.100.1) port 2000 (#0)
    * Establish HTTP proxy tunnel to ccc:443
    > CONNECT ccc:443 HTTP/1.1
    > Host: ccc:443
    > User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.16.2.3 Basic ECC zlib/1.2.3 libidn/1.18 libssh2/1.4.2
    > Proxy-Connection: Keep-Alive
    > 
    < HTTP/1.1 200 Connection established
    < 
    * Proxy replied OK to CONNECT request
    * Initializing NSS with certpath: sql:/etc/pki/nssdb
    * warning: ignoring value of ssl.verifyhost
    * NSS error -5938
    * Closing connection #0
    * SSL connect error
    curl: (35) SSL connect error
    ```
    Fix this by unsetting proxy settings:
    ```bash
    >unset https_proxy
    >unset http_proxy
    ```
    
    
    
    
6. **Update firewall configurations to whitelist traffic to Registry.**

    _// At this time, there are no firewall impediments between compute(c11) and registry(v22)_
    Only HTTPS traffic from gateway and compute nodes should be able to access the Registry.
    
    After that, Docker clients should be able to access our Registry! We can test by SSHing into a compute node and running:

    ```bash
    > curl -k https://ccc.docker/v2/
    {}
```


### Testing ###
We can easily wrap one of the pre-existing tools with a base Docker image to verify that our private registry is working as expected.

1. **Pull a public base image.**

    From the gateway node, run:
   
    ```bash
    > sudo docker pull centos:6.6
    ```
   
2. **Push that image to our private registry.**

    On the gateway node, create a file named **`Dockerfile`**
    ```
    # base image for all 
    FROM centos:6.6
    # for centos this must be set for the child image 
    # setenforce returns a "1" exit code, docker build interprets this as an error
    # so, call getenforce which returns "0"
    RUN setenforce 0 ; getenforce
    #install perl which the cut tool uses.  requires internet access     
    RUN yum install -y perl
    
    ```
    Use  this to create a tagged image.  Note we insert a ENV statement after the FROM statement to enable internet access by passing the **`http_proxy`** variable.  This allows us to create portable Dockerfiles.
    ```
    $ sed "/FROM.*/a ENV http_proxy=$http_proxy" Dockerfile | docker build -t ccc.docker/cut-wrapper -
    ```
    
    
    Once that's done, we should be able to push that image to the registry:
    
    ```bash
    $sudo docker push ccc.docker/cut-wrapper:latest
    ```
    Then, on a compute node, you can run a simple command line tests
        
    ```bash
    $ sudo docker run  ccc.docker/cut-wrapper perl -v
    $ sudo docker run  -v /tmp:/my-tmp ccc.docker/cut-wrapper  ls -l /my-tmp
    ```

3. [**Update a tool to use that Docker image.**](#job_conf)

    _// Before changing a galaxy tool to use docker, we need to enable galaxy to launch docker_

    Modify job_conf.xml  - minmum configuration to enable docker 
    
    ```xml
    <destinations>
      <destination id="local" runner="local">
        <param id="docker_enabled">true</param>
      </destination>
   </destinations>
   ```

  A more involved example. See galaxy's [advanced job conf](https://bitbucket.org/galaxy/galaxy-central/src/d301ac50aa86a94e230d44eb2ae10c6c0e354b88/job_conf.xml.sample_advanced?at=default)
   ```xml
<?xml version="1.0"?>
<!-- A sample job config that explicitly configures job running the way it is configured by default (if there is no explicit config). -->
<job_conf>
    <plugins>
        <plugin id="local" type="runner" load="galaxy.jobs.runners.local:LocalJobRunner" workers="4"/>
    </plugins>
    <handlers>
        <handler id="main"/>
    </handlers>
    <destinations>
        <destination id="local" runner="local">
          <param id="docker_enabled">true</param>
          <param id="docker_volumes">$defaults,/opt/Galaxy:/opt/Galaxy:ro</param>
          <param id="docker_env_foo">bar</param>
        </destination>
    </destinations>
</job_conf>
   
   ```


    Pick a simple tool, like `galaxy/tools/filter/cutWrapper.pl`. Modify the top of the XML file so that it reads:
    
    ```xml
    <tool id="Cut1" name="Cut" version="1.0.2">
      <requirements>
    	<container type="docker">ccc.docker/cut-wrapper</container>
      </requirements>
      <description>columns from a table</description>
      <command interpreter="perl">cutWrapper.pl $input "$columnList" $delimiter $out_file1</command>
      <inputs>
        <param name="columnList" size="10" type="text" value="c1,c2" label="Cut columns"/>
        <param name="delimiter" type="select" label="Delimited by">
          <option value="T">Tab</option>
          <option value="Sp">Whitespace</option>
    ```
    
    (Note the added `<requirements>` block.)
    
    Push this tool to Galaxy and run the tool to see if it works. The compute node should pull the correct image from `ccc.docker/cut-wrapper:latest` on the gateway registry.

  _// Note: If you get the following error, you will need to disable tty 
  
    > error
    An error occurred with this dataset:
    sudo: sorry, you must have a tty to run sudo  

  ```bash
  $ sudo visudo
  
  #
  # Disable "ssh hostname sudo <cmd>", because it will show the password in clear.
  #         You have to run "ssh -t hostname sudo <cmd>".
  #
  #Defaults    requiretty
  ```
   
  More:
    https://wiki.galaxyproject.org/Admin/Tools/Docker
    https://github.com/apetkau/galaxy-hackathon-2014
    http://unix.stackexchange.com/questions/122616/why-do-i-need-a-tty-to-run-sudo-if-i-can-sudo-without-a-password


[**BWA Dockerfile**](#bwa-dockerfile)  

  Docker context
  ```
  bwa]$ ls -l
drwxr-xr-x 2 walshbr ohsu 4096 Jun 11 19:01 bwa-0.7.4
-rw-r--r-- 1 walshbr ohsu  194 Jun 11 19:15 Dockerfile
  ```
 

  ```bash
  # same as host-os
  FROM centos:6.6
  # for support
  MAINTAINER Intel CCC
  
  # assumes bwa-0.7.4 in current directory
  COPY bwa-0.7.4 /bwa-0.7.4/
  # set path for tool wrapper
  ENV PATH=/bwa-0.7.4:$PATH
  
  ```

[**GATK Dockerfile**](#gatk-dockerfile)  

  Docker context
  ```
$ ls -l
-rw-r--r-- 1 walshbr ohsu 1396 Jun 12 14:18 Dockerfile
drwxrwxrwx 3 walshbr ohsu 4096 Jun 12 11:08 resources
$ ls -l resources/
-rwxrwxrwx 1 walshbr ohsu 12020164 Jun 12 11:02 GenomeAnalysisTK.jar
drwxrwxrwx 7 walshbr ohsu     4096 Jun 26  2014 samtools-0.1.19
  ```

  ```bash
  # GATK docker file
  # same as host-os
  FROM centos:6.6
  # for support
  MAINTAINER Intel CCC
  # since we are building behind a firewall, we need to set these variables
  # caution: these variables are set in the "pushed" image as well
  ENV http_proxy=sparkdmz1:2000
  ENV https_proxy=sparkdmz1:2000
  ENV socks_proxy=sparkdmz1:2001
  ENV no_proxy=spark0.intel.com,192.168.100.0/24,localhost,127.0.0.0/8
  # we'll need a few tools
  RUN yum -y update && yum -y install \
  python \
  tar \
  wget
  # install Oracle JDK 1.7 since MuTect 1.1.7 only runs with Oracle JDK 1.7 and not OpenJDK or Oracle JDK 1.8
  RUN  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz
  RUN tar -xvzf jdk-7u79-linux-x64.tar.gz
  # create a link in /usr/bin for java so container can run it from the working dir
  ENV PATH /jdk1.7.0_79/bin:$PATH
  # copy our resources into the container
  COPY resources /resources/
  RUN chmod a+x /resources/samtools-0.1.19
  # set the environmental variables the tool will use
  ENV SAMTOOLS_DIR=/resources/samtools-0.1.19
  ENV GATK_JAR_PATH=/resources/GenomeAnalysisTK.jar
  ENV PATH=$SAMTOOLS_DIR:$PATH
  ```

[Galaxy Changes](#galaxy-changes)

  ```bash
    #job_conf.xml  
      <destination id="local" runner="local">
+       <param id="docker_enabled">true</param>
+       <param id="docker_volumes">$defaults,/opt/Galaxy:/opt/Galaxy:ro </param>
      </destination> 
    #tools/bwa/bwa_mem.xml
      <requirements>
       <requirement type="package" version="0.7.9"> </requirement>
+      <container type="docker">ccc.docker/bwa</container>
      </requirements>
    #/tools/gatk/gatk2_macros.xml
       <requirement type="package" version="0.1.19">samtools</requirement>
       <requirement type="set_environment">GATK2_PATH</requirement>
       <requirement type="set_environment">GATK2_SITE_OPTIONS</requirement>
+      <container type="docker">ccc.docker/gatk</container>
     </requirements>


  ```


    
### Next steps ###

1. Modify /opt 'sweeper' to maintain /opt/docker-registry & /opt/docker-registry-images
2. Identify what pipelines we're going to want to Dockerize.
3. Identify software requirements for each Docker tool. Some tools may require a custom software installed (bwa, picard, etc) or custom Python packages installed (`pip install numpy`, etc).
4. Fine-tune the Registry configuration. How can we have better logging? Can we use Redis-based caching to improve performance? Do we want notifications when new images are pushed up? Do we want authentication on pushing new images?




