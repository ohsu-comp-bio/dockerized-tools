# Identifying recurrent mutations in cancer

#### Description: 
This is a method to identify population-scale recurrent mutations in cancer based on a binomial
statisical model that incoporates underlying mutational processes including nucleotide context
mutability, gene-specific mutation rates, and major expected patterns of hotspot mutation emergence

#### Paper & Source Code

* [Paper link](http://www.nature.com/nbt/journal/v34/n2/full/nbt.3391.html)
* [Source code](https://github.com/taylor-lab/hotspots)

##### Building the Docker Image

    docker build -t taylor-lab-hotspots

#### Usage:
This script requires `Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz` which can be downloaded [here](http://ftp.ensembl.org/pub/grch37/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz). 
At runtime you must mount this file into the container at `/mnt/`.

```
docker run -v </path/to/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz>:/mnt/Homo_sapiens.GRCh37.dna.primary_assembly.fa.gz taylor-lab-hotspots hotspot_algo.R
    --input-maf=[REQUIRED: mutation file]
    --rdata=[REQUIRED: Rdata object with necessary files for algorithm]
    --output-file=[REQUIRED: output file to print statistically significant hotspots]
    --gene-query=[OPTIONAL (default=all genes in mutation file): List of Hugo Symbol in which to query for hotspots]
    --homopolymer=[OPTIONAL (default=TRUE): TRUE|FALSE filter hotspot mutations in homopolymer regions]
    --filter-centerbias=[OPTIONAL (default=FALSE): TRUE|FALSE to identify false positive filtering based on mutation calling center bias]
    --align100mer=[OPTIONAL: BED file of hg19 UCSC alignability track for 100-mer length sequences for false positive filtering]
    --align24mer=[OPTIONAL: BED file of hg19 UCSC alignability track for 24-mer length sequences for false positive filtering]
```

### Notes:

`--align100mer` and `--align24mer` are optional filters based on how uniquely k-mer sequences align to a region of the hg19 genome. Note, both filters were used as part of this analysis. See more information at [ENCODE Mapability](http://genome.ucsc.edu/cgi-bin/hgFileUi?db=hg19&g=wgEncodeMapability).

The use of these filters will require downloading the 100-mer and 24-mer alignability tracks from UCSC that are not included here:

* [ENCODE CRG Alignability 100-mer](http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeMapability/wgEncodeCrgMapabilityAlign100mer.bigWig)
* [ENCODE CRG Alignability 24-mer](http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeMapability/wgEncodeCrgMapabilityAlign24mer.bigWig)
                                                        
Convert these downloaded bigWig to bedgraph format, following instructions here: [UCSC BigWig](http://genome.ucsc.edu/goldenpath/help/bigWig.html)
