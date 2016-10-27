task table_annovar {
   File annovarInput
   File annovarDatabase
   Array[String]+ protocol
   Array[String]+ operation
   String build = "hg19"
   String nastring = "."
   String outputFilePrefix

   command {
       table_annovar.pl ${annovarInput} \
                        ${annovarDatabase} \
                        --protocol ${sep="," protocol} \
                        --operation ${sep="," operation} \
                        --build ${build} \
                        --nastring ${nastring} \
                        --outfile ${outputFilePrefix}
   }

   output {
       File multianno = "${outputFilePrefix}.${build}_multianno.txt"
   }

   runtime {
         docker: "annovar"
   }
}

workflow annovar {
    call table_annovar
}
