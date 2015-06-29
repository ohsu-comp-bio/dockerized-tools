MASTER_RESOURCES='/opt/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp $MASTER_RESOURCES/ohsu/dnapipeline/picard-tools-1.110/* ./resources
#build the Docker image
sudo docker build -t ccc.docker/picard:latest -f Picard.Dockerfile .
#push the image to the CCC Docker image repository
#sudo docker push ccc.docker/picard:latest

