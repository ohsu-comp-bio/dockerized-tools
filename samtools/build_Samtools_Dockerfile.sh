MASTER_RESOURCES='/opt/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp $MASTER_RESOURCES/ohsu/dnapipeline/samtools-0.1.19/samtools ./resources
#build the Docker image
sudo docker build -t ccc.docker/samtools:latest -f Samtools.Dockerfile .
#push the image to the CCC Docker image repository
#sudo docker push ccc.docker/samtools:latest

