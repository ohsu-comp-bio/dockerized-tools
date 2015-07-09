MASTER_RESOURCES='/opt/sync/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp $MASTER_RESOURCES/ohsu/dnapipeline/picard-tools-1.110/* ./resources
#build the Docker image
cat Picard.Dockerfile | sed '/LOCAL_ENV_START/a ENV http_proxy='$HTTP_PROXY' https_proxy='$HTTPS_PROXY > Dockerfile 
sudo docker build -t ccc.docker/picard:latest .
#push the image to the CCC Docker image repository
sudo docker push ccc.docker/picard:latest
rm Dockerfile
