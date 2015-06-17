MASTER_RESOURCES='/opt/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp -r $MASTER_RESOURCES/ohsu/dnapipeline/bwa-0.7.4 ./resources
sudo docker build -t ccc.docker/bwa .
