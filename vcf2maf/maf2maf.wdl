task maf2maf {
    File inputMAF
    File? customEnst
    String? tumDepthCol
    String? tumRadCol
    String? tumVadCol
    String? nrmDepthCol
    String? nrmRadCol
    String? nrmVadCol
    Array[String]? retainCols
    String vepPath = "~/vep"
    File vepOfflineCacheDir = "~/.vep"
    File refFasta = "~/.vep/homo_sapiens/84_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz"
    File refFastaFai = "~/.vep/homo_sapiens/84_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz.fai"
    String ncbiBuild = "GRCh37"
    String species = "homo_sapiens"
    String outputDir
    String outputFilePrefix

    command {
        # Handling the optional arrays
        if [ -n '${sep="," retainCols}' ]; then
            RETAIN_COLS_FLAG=--apply-filters ${sep="," retainCols}
        else
            RETAIN_COLS_FLAG=''
        fi

        perl /home/maf2maf.pl --input-maf ${inputMAF} \
                              --output-maf ${outputDir}/${outputFilePrefix}.maf
                              ${"--tum-depth-col " + tumDepthCol} \
                              ${"--tum-rad-col " + tumRadCol} \
                              ${"--tum-vad-col " + tumVadCol} \
                              ${"--nrm-depth-col " + nrmDepthCol} \
                              ${"--nrm-rad-col " + nrmRadCol} \
                              ${"--nrm-vad-col " + nrmVadCol} \
                              ${"--custom-enst " + customEnst} \
                              $RETAIN_COLS_FLAG \
                              --vep-path ${vepPath} \ 
                              --vep-data ${vepOfflineCacheDir} \
                              --ref-fasta ${refFasta} \                              
                              --species ${species} \
                              --ncbi-build ${ncbiBuild}
    }

    output {
        File maf = "${outputDir}/${outputFilePrefix}.maf"
    }

    runtime {
        docker: "vcf2maf"
    }
}

workflow run {
    call maf2maf
}
