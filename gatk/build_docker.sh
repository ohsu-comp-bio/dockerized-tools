MASTER_RESOURCES='/opt/sync/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp -r $MASTER_RESOURCES/ohsu/dnapipeline/samtools-0.1.19 ./resources
cp $MASTER_RESOURCES/ohsu/dnapipeline/gatk/dist/GenomeAnalysisTK.jar ./resources
cat gatk.dockerfile | sed '/LOCAL_ENV_START/a ENV http_proxy='$HTTP_PROXY' https_proxy='$HTTPS_PROXY > Dockerfile
sudo docker build -t ccc.docker/gatk .
sudo docker push ccc.docker/gatk:latest
rm Dockerfile
