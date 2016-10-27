vcf2maf
=======

To convert a [VCF](http://samtools.github.io/hts-specs/) into a [MAF](https://wiki.nci.nih.gov/x/eJaPAQ), each variant must be mapped to only one of all possible gene transcripts/isoforms that it might affect. This selection of a single effect per variant, is often subjective. So this project is an attempt to make the selection criteria smarter, reproducible, and more configurable. And the default criteria must lean towards best practices.

Quick start
-----------

Clone this repo and build the image:
    
    docker build -t vcf2maf .
        
        
To view the vcf2maf source code, [click here](https://github.com/mskcc/vcf2maf/).

After building the image, you can test it like so:

    docker run -v /vep/data/path/homo_sapiens:/mnt/homo_sapiens vcf2maf perl vcf2maf.pl --input-vcf data/test.vcf --output-maf data/test.vep.maf --vep-data /mnt/ --ref-fasta /mnt/homo_sapiens/84_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz


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

Download and index a custom ExAC r0.3 VCF, that skips variants overlapping known somatic hotspots:

    curl -L ftp://ftp.broadinstitute.org:/pub/ExAC_release/release0.3.1/subsets/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz > $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
    bcftools filter --targets ^2:25457242-25457243,12:121176677-121176678 --output-type b --output $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.minus_somatic.vep.vcf.gz $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
    mv -f $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.minus_somatic.vep.vcf.gz $VEP_DATA/ExAC_nonTCGA.r0.3.1.sites.vep.vcf.gz
    tabix -p vcf $VEP_DATA/ExAC.r0.3.sites.minus_somatic.vcf.gz

Convert the offline cache for use with tabix, that significantly speeds up the lookup of known variants:

    docker run -v $VEP_DATA:/mnt vcf2maf perl /root/vep/convert_cache.pl --species homo_sapiens --version 86_GRCh37 --dir /mnt


License
-------
    
    Apache-2.0 | Apache License, Version 2.0 | https://www.apache.org/licenses/LICENSE-2.0
