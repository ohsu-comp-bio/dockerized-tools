vcf2maf
=======

To convert a [VCF](http://samtools.github.io/hts-specs/) into a [MAF](https://wiki.nci.nih.gov/x/eJaPAQ), each variant must be mapped to only one of all possible gene transcripts/isoforms that it might affect. This selection of a single effect per variant, is often subjective. So this project is an attempt to make the selection criteria smarter, reproducible, and more configurable. And the default criteria must lean towards best practices.

Quick start
-----------

Clone this repo, build the image and view the detailed usage manual:
    
    docker build -t vcf2maf .
    docker run vcf2maf
        
To view the vcf2maf source code, [click here](https://github.com/mskcc/vcf2maf/).

After installing building the image, you can test it like so:

    docker run -v /vep/data/path:/srv/vep/ vcf2maf perl vcf2maf.pl --input-vcf data/test.vcf --output-maf data/test.vep.maf --vep-data /srv/vep

Note that you must mount in the cached vep data. If you don't have the [VEP](http://useast.ensembl.org/info/docs/tools/vep/index.html) data, then [follow this gist](https://gist.github.com/ckandoth/57d189f018b448774704d3b2191720a6) to generate it.


License
-------
    
    Apache-2.0 | Apache License, Version 2.0 | https://www.apache.org/licenses/LICENSE-2.0
