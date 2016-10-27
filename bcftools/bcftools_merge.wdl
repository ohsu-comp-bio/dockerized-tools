task merge {
    Array[File]+ vcf_files
    Array[File]+ vcf_files_tbi
    File? use_header
    File? regions_file
    Array[String]? apply_filters
    Array[String]? info_rules
    Array[String]? regions
    Boolean? force_samples
    Boolean? print_header
    Boolean? no_version
    String? merge
    String output_type = 'z'
    String output_file_prefix
    Int threads = 3
    
    command {
        # Handling the optional arrays
        if [ -n '${sep="," apply_filters}' ]; then
            FILTER_FLAG=--apply-filters ${sep="," apply_filters}
        else
            FILTER_FLAG=''
        fi
    
        if [ -n '${sep="," info_rules}' ]; then
            RULES_FLAG=--info-rules ${sep="," info_rules}
        else
            RULES_FLAG=''
        fi
    
        if [ -n '${sep="," regions}' ]; then
            REGIONS_FLAG=--regions ${sep="," regions}
        else
            REGIONS_FLAG=''
        fi
    
        bcftools merge \
        ${true="--force-samples" false="" force_samples} \
        ${true="--print-header" false="" print_header} \
        ${true="--no-version" false="" no_version} \
        $FILTER_FLAG \
        $RULES_FLAG \
        $REGIONS_FLAG \
        ${"--regions-file " + regions_file} \
        ${"--use-header " + use_header} \
        ${"--merge " + merge} \
        ${"--threads " + threads} \
        --output-type ${output_type} \
        --output ${output_file_prefix}.vcf.gz \
        ${sep=" " vcf_files}
    }
    
    output {
        File merged_vcf = "${output_file_prefix}.vcf.gz"
    }

    runtime {
        docker: "bcftools"
    }

}

workflow bcftools {
    call merge
}
