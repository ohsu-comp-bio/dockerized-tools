task variant_effect_predictor {

    File inputFile
    File refFasta
    File refFastaFai
    File cacheDir
    File? pluginsDir

    String species = "homo_sapiens"
    String assembly = "GRCh37"
    String format = "vcf"

    String outputDir
    String outputFileName

    # output format options
    Boolean vcf = false
    Boolean tab = false
    Boolean json = false
    Boolean gvcf = false
    Boolean minimal = false

    # output options
    Boolean humdiv = false
    Boolean gene_phenotype = false
    Boolean regulatory = false
    Boolean phased = false
    Boolean allele_number = false
    Boolean total_length = false
    Boolean numbers = false
    Boolean domains = false
    Boolean no_escape = false
    Boolean keep_csq = false
    Boolean no_consequences = false

    String? cell_type
    String? plugin
    String? individual
    String? sift
    String? polyphen
    String? vcf_info_field
    String? terms

    # identifiers
    Boolean hgvs = false
    Boolean protein = false
    Boolean symbol = false
    Boolean ccds = false
    Boolean uniprot = false
    Boolean tsl = false
    Boolean appris = false
    Boolean canonical = false
    Boolean biotype = false
    Boolean xref_refseq = false
    


    command {
        perl /home/variant_effect_predictor.pl \
        --no_progress \
        --no-stats \
        --offline \
        --input_file ${inputFile} \
        --format ${format} \
        --species ${species} \
        --assembly ${assembly} \
        --fasta ${refFasta} \
        --dir_cache ${cacheDir} \
        ${"--dir_plugins " + pluginsDir} \

        # output options
        ${'--cell_type ' + cell_type} \
        ${'--plugin ' + plugin} \
        ${'--individual ' + individual} \
        ${'--sift ' + sift} \
        ${'--polyphen ' + polyphen} \
        ${'--vcf_info_field ' + vcf_info_field} \
        ${'--terms ' + terms} \
        ${true='--humdiv' false='' humdiv} \
        ${true='--gene_phenotype' false='' gene_phenotype} \
        ${true='--regulatory' false='' regulatory} \
        ${true='--phased' false='' phased} \
        ${true='--allele_number' false='' allele_number} \
        ${true='--total_length' false='' total_length} \
        ${true='--numbers' false='' numbers} \
        ${true='--domains' false='' domains} \
        ${true='--no_escape' false='' no_escape} \
        ${true='--keep_csq' false='' keep_csq} \
        ${true='--no_consequences' false='' no_consequences} \

        # identifiers
        ${true='--hgvs' false='' hgvs} \
        ${true='--protein' false='' protein} \
        ${true='--symbol' false='' symbol} \
        ${true='--ccds' false='' ccds} \
        ${true='--uniprot' false='' uniprot} \
        ${true='--tsl' false='' tsl} \
        ${true='--appris' false='' appris} \
        ${true='--canonical' false='' canonical} \
        ${true='--biotype' false='' biotype} \
        ${true='--xref_refseq' false='' xref_refseq} \

        # output format
        ${true='--vcf' false='' vcf} \
        ${true='--tab' false='' tab} \
        ${true='--json' false='' json} \
        ${true='--gvcf' false='' gvcf} \
        ${true='--minimal' false='' minimal} \
        --output_file ${outputDir}/${outputFileName}
    }

    output {
        File annotatedFile = "${outputDir}/${outputFileName}"
    }

    runtime {
        docker: "vep"
    }
}

workflow vep {
    call variant_effect_predictor
}
