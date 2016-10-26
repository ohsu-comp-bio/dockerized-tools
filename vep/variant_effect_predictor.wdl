task variant_effect_predictor {
    File inputFile
    String outputFileName
    File refFasta
    File refFastaFai
    File cacheDir
    File? pluginsDir
    Int? fork

    String species = "homo_sapiens"
    String assembly = "GRCh37"
    String format = "vcf"

    # shortcut for common flags
    Boolean everything = false

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
    Boolean variant_class = false

    String? cell_type
    String? plugin
    String? pluginFileName
    Array[String]? pluginArgs
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
    Int? shift_hgvs

    # co-located variants
    Boolean check_existing = false
    Boolean check_alleles = false
    Boolean check_svs = false
    Boolean gmaf = false
    Boolean maf_1kg = false
    Boolean maf_esp = false
    Boolean maf_exac = false
    Boolean old_maf = false
    Boolean pubmed = false
    Int? failed
    
    
    command {
       # plugins
        if [ -n '${sep=',' pluginArgs}' ]; then
           PLUGINS=${'--plugin "' + plugin + "," + cacheDir + "/" + pluginFileName + ","}${sep=',' pluginArgs}"
        else
           PLUGINS=${'--plugin "' + plugin + "," + cacheDir + "/" + pluginFileName + '"'}
        fi

        variant_effect_predictor.pl \
        --no_progress \
        --no_stats \
        --offline \
        --input_file ${inputFile} \
        --format ${format} \
        --species ${species} \
        --assembly ${assembly} \
        --fasta ${refFasta} \
        --dir_cache ${cacheDir} \
        ${"--dir_plugins " + pluginsDir} \
        ${"--fork " + fork} \

        # plugins
        $PLUGINS \

        # output options
        ${'--cell_type ' + cell_type} \
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
        ${true='--variant_class' false='' variant_class} \

        # identifiers
        ${'--shift_hgvs ' + shift_hgvs} \
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

        # co-located variants
        ${true='--check_existing' false='' check_existing} \
        ${true='--check_alleles' false='' check_alleles} \
        ${true='--check_svs' false='' check_svs} \
        ${true='--gmaf' false='' gmaf} \
        ${true='--maf_1kg' false='' maf_1kg} \
        ${true='--maf_esp' false='' maf_esp} \
        ${true='--maf_exac' false='' maf_exac} \
        ${true='--old_maf' false='' old_maf} \
        ${true='--pubmed' false='' pubmed} \
        ${'--failed ' + failed} \

        # output format
        ${true='--vcf' false='' vcf} \
        ${true='--tab' false='' tab} \
        ${true='--json' false='' json} \
        ${true='--gvcf' false='' gvcf} \
        ${true='--minimal' false='' minimal} \
        --output_file ${outputFileName}
    }

    output {
        File annotatedFile = "${outputFileName}"
    }

    runtime {
        docker: "vep"
    }
}

workflow vep {
    call variant_effect_predictor
}
