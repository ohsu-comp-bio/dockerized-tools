task table_annovar {
   File annovarInput
   File annovarDatabase
   Array[String]+ protocol
   Array[String]+ operation
   String build = "hg19"
   String nastring = "."
   String outputFilePrefix
   String outputDir = "."

   command {
       mkdir -p ${outputDir};
       cd ${outputDir};
       table_annovar.pl ${annovarInput} \
                        ${annovarDatabase} \
                        --protocol ${sep="," protocol} \
                        --operation ${sep="," operation} \
                        --build ${build} \
                        --nastring ${nastring} \
                        --outfile ${outputFilePrefix}
   }

   output {
       File multianno = "${outputDir}/${outputFilePrefix}.${build}_multianno.txt"
   }

   runtime {
         docker: "annovar"
   }
}

workflow annovar {
    call table_annovar
}
