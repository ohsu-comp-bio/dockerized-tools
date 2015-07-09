MASTER_RESOURCES='/opt/sync/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp $MASTER_RESOURCES/ohsu/dnapipeline/picard-tools-1.110/CreateSequenceDictionary.jar ./resources
cp $MASTER_RESOURCES/ohsu/dnapipeline/samtools-0.1.19/samtools ./resources
cp $MASTER_RESOURCES/ohsu/dnapipeline/mutect-1.1.7.jar ./resources
#build the Docker image
cat MuTect.Dockerfile | sed '/LOCAL_ENV_START/a ENV http_proxy='$HTTP_PROXY' https_proxy='$HTTPS_PROXY > Dockerfile
sudo docker build -t ccc.docker/mutect:latest .
#push the image to the CCC Docker image repository
sudo docker push ccc.docker/mutect:latest
rm Dockerfile
