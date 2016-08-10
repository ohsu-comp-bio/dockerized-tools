task vcf2maf {
    File inputVCF
    File vepOfflineCacheDir
    File refFasta
    File refFastaFai
    String ncbiBuild
    String outputDir
    String outputFilePrefix

    command {
        perl /home/vcf2maf.pl --input-vcf ${inputVCF} \
                        --output-maf ${outputDir}/${outputFilePrefix}.maf \
                        --ref-fasta ${refFasta} \
                        --ncbi-build ${ncbiBuild} \
                        --vep-data ${vepOfflineCacheDir}
    }

    output {
        File maf = "${outputDir}/${outputFilePrefix}.maf"
    }

    runtime {
        docker: "vcf2maf"
    }
}
