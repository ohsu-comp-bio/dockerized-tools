task call_hotspots {
     File inputMAF
     File refFasta
     File refFastaFai
     File? geneQuery
     File? align100mer
     File? align24mer
     String homopolymer = "TRUE"
     String filterCenterBias = "FALSE"
     String naStringRegEx = "\\."
     String outputFilePrefix

     command {
         # link ref files to expected location
         ln -s ${refFasta} /mnt/Homo_sapiens.GRCh37.dna.primary_assembly.fa;
         ln -s ${refFastaFai} /mnt/Homo_sapiens.GRCh37.dna.primary_assembly.fa.fai;

         # replace NA strings with what the algorithm expects
         sed 's/${naStringRegEx}/NA/g' ${inputMAF} > tmp.maf;

         # call hotspot algorithm
         Rscript /home/hotspot_algo.R --input-maf=tmp.maf \
                                --rdata=/home/hotspot_algo.Rdata \
                                ${"--gene-query=" + geneQuery} \
                                ${"--align100mer=" + align100mer} \
                                ${"--align24mer=" + align24mer} \
                                --homopolymer=${homopolymer} \
                                --filter-centerbias=${filterCenterBias} \
                                --output-file=${outputFilePrefix}.txt;

        # cleanup
        rm tmp.maf /mnt/$(basename ${refFasta}) /mnt/$(basename ${refFastaFai})
     }

     output {
         File hotspots = "${outputFilePrefix}.txt"
     }

     runtime {
         docker: "taylor-lab-hotspots"
     }
}

workflow taylor_lab_hotspots {
    call call_hotspots 
}
