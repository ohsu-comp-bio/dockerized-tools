VEP
=======

[Documentation](http://uswest.ensembl.org/info/docs/tools/vep/index.html)

Quick start
-----------

Clone this repo and build the image:
    
    docker build -t vep .


After building the image and downloading the offline cache, you can test the image like so:

    docker run -v /vep/data/path/homo_sapiens:/mnt/homo_sapiens vep variant_effect_predictor.pl --species homo_sapiens --assembly GRCh37 --offline --no_progress --no_stats --vcf --minimal --dir $VEP_DATA --fasta $VEP_DATA/homo_sapiens/86_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz --input_file example_GRCh37.vcf --output_file /opt/ensembl-tools-release-84/scripts/variant_effect_predictor/example_GRCh37.vep.vcf --everything --dir_cache /mnt/


Download and Prepare VEP Data Dependencies
-----------

Download and unpack VEP's offline cache for GRCh37

    export VEP_DATA = /home/.vep
    cd $VEP_DATA
    rsync -zvh rsync://ftp.ensembl.org/ensembl/pub/release-86/variation/VEP/homo_sapiens_vep_86_GRCh37.tar.gz $VEP_DATA
    tar xvfz homo_sapiens_vep_86_GRCh37.tar.gz
    wget http://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
    gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
    bgzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz

Download and index a custom ExAC r0.3.1 VCF, that skips variants overlapping known somatic hotspots:

    curl -L ftp://ftp.broadinstitute.org:/pub/ExAC_release/release0.3.1/subsets/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz > $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
    bcftools filter --targets ^2:25457242-25457243,12:121176677-121176678 --output-type b --output $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.minus_somatic.vep.vcf.gz $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
    mv -f $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.minus_somatic.vep.vcf.gz $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
    tabix -p vcf $VEP_DATA/ExAC.r0.3.sites.minus_somatic.vcf.gz


Download and index the files required for the dbNSFP plugin:

    wget ftp://dbnsfp:dbnsfp@dbnsfp.softgenetics.com/dbNSFPv3.2a.zip
    unzip dbNSFPv3.2a.zip
    head -n1 dbNSFP3.2a_variant.chr1 > h
    cat dbNSFP3.2a_variant.chr* | grep -v ^#chr | sort -k1,1 -k2,2n - | cat h - | bgzip -c > dbNSFP.gz
    tabix -s 1 -b 2 -e 2 dbNSFP.gz


Convert the offline cache for use with tabix, that significantly speeds up the lookup of known variants:

    docker run -v $VEP_DATA:/mnt vep /root/vep/convert_cache.pl --species homo_sapiens --version 86_GRCh37 --dir /mnt
