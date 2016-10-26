task vcf2maf {
    File inputVCF
    File? vepAnnotatedInputVCF
    String? tmpDir
    String? tumorId
    String? normalId
    String? vcfTumorId
    String? vcfNormalId
    File? customEnst
    String vepPath = "~/vep"
    File vepOfflineCacheDir = "~/.vep"
    File refFasta = "~/.vep/homo_sapiens/84_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz"
    File refFastaFai = "~/.vep/homo_sapiens/84_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz.fai"
    String ncbiBuild = "GRCh37"
    String species = "homo_sapiens"
    String? mafCenter
    Float? minHomVaf
    String outputFilePrefix

    command {            
        if [ -n '${vepAnnotatedInputVCF}' ]; then
            ln -s ${vepAnnotatedInputVCF} ${tmpDir + "/"}$(basename ${inputVCF} .vcf).vep.vcf
        fi

        perl /home/vcf2maf.pl --input-vcf ${inputVCF} \
                              --output-maf ${outputFilePrefix}.maf \
                              ${"--tmp-dir " + tmpDir} \
                              ${"--tumor-id " + tumorId} \
                              ${"--normal-id " + normalId} \
                              ${"--vcf-tumor-id " + vcfTumorId} \
                              ${"--vcf-normal-id " + vcfNormalId} \
                              ${"--custom-enst " + customEnst} \
                              --vep-path ${vepPath} \ 
                              --vep-data ${vepOfflineCacheDir} \
                              --ref-fasta ${refFasta} \                              
                              --species ${species} \
                              --ncbi-build ${ncbiBuild} \
                              ${"--maf-center " + mafCenter} \ 
                              ${"--min-hom-vaf " + minHomVaf}
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
