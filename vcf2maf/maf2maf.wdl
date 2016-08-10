task maf2maf {
    File inputMAF
    File vepOfflineCacheDir
    File refFasta
    File refFastaFai
    String ncbiBuild
    String outputDir
    String outputFilePrefix

    command {
        perl /home/maf2maf.pl --input-maf ${inputMAF} \
                        --output-maf ${outputDir}/${outputFilePrefix}.maf
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
