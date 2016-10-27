task vcf2maf {
    File inputVCF
    File? vepAnnotatedInputVCF
    String tmpDir = "."
    File vepOfflineCacheDir
    File? vepPath
    File refFasta
    File refFastaFai
    String ncbiBuild = "GRCh37"
    String species = "homo_sapiens"
    String? tumorId
    String? normalId
    String? vcfTumorId
    String? vcfNormalId
    File? customEnst
    String? mafCenter
    Float? minHomVaf
    String outputFilePrefix

    command {            
        if [ -n "${vepAnnotatedInputVCF}" ]; then
            ln -s ${vepAnnotatedInputVCF} ${tmpDir + "/"}$(basename ${inputVCF} .vcf).vep.vcf
        fi

        perl /home/vcf2maf.pl --input-vcf ${inputVCF} \
                              --output-maf ${outputFilePrefix}.maf \
                              --vep-data ${vepOfflineCacheDir} \
                              --ref-fasta ${refFasta} \                              
                              --species ${species} \
                              --ncbi-build ${ncbiBuild} \
                              ${"--vep-path " + vepPath} \ 
                              ${"--maf-center " + mafCenter} \ 
                              ${"--tmp-dir " + tmpDir} \
                              ${"--tumor-id " + tumorId} \
                              ${"--normal-id " + normalId} \
                              ${"--vcf-tumor-id " + vcfTumorId} \
                              ${"--vcf-normal-id " + vcfNormalId} \
                              ${"--custom-enst " + customEnst} \
                              ${"--min-hom-vaf " + minHomVaf}

       rm ${tmpDir + "/"}$(basename ${inputVCF} .vcf).vep.vcf
    }

    output {
        File maf = "${outputFilePrefix}.maf"
    }

    runtime {
        docker: "vcf2maf"
    }
}

workflow run {
    call vcf2maf
}
