MASTER_RESOURCES='/opt/Genomics'
if [ ! -d resources ]; then
    mkdir resources
fi
cp -r $MASTER_RESOURCES/ohsu/dnapipeline/samtools-0.1.19 ./resources
cp $MASTER_RESOURCES/ohsu/dnapipeline/gatk/dist/GenomeAnalysisTK.jar ./resources
sudo docker build -t ccc.docker/gatk .

