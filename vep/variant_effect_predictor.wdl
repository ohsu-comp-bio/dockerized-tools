task variant_effect_predictor {
    File inputFile
    File refFasta
    File refFastaFai
    File cacheDir
    File pluginDir
    String species
    String format = "vcf"
    String outputDir
    String outputFilePrefix

    command {
        perl /home/variant_effect_predictor.pl \
        --no_progress \
        --no-stats \
        --offline \
        --input_file ${inputFile} \
        --format ${format} \
        --species ${species} \
        --fasta ${refFasta} \
        --dir_cache ${cacheDir} \
        --dir_plugins ${pluginsDir} \
        --output_file ${outputDir}/${outputFilePrefix}
    }

    output {
        File annotatedFile = "${outputDir}/${outputFilePrefix}"
    }

    runtime {
        docker: "vep"
    }
}

workflow vep {
    call variant_effect_predictor
}
