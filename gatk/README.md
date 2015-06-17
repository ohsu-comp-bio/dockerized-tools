[**GATK Dockerfile**](#gatk-dockerfile)  

  Docker context
  ```
$ ls -l
-rw-r--r-- 1 walshbr ohsu 1396 Jun 12 14:18 Dockerfile
drwxrwxrwx 3 walshbr ohsu 4096 Jun 12 11:08 resources
$ ls -l resources/
-rwxrwxrwx 1 walshbr ohsu 12020164 Jun 12 11:02 GenomeAnalysisTK.jar
drwxrwxrwx 7 walshbr ohsu     4096 Jun 26  2014 samtools-0.1.19
  ```

[Galaxy Changes](#galaxy-changes)

  ```bash
    #job_conf.xml  
      <destination id="local" runner="local">
+       <param id="docker_enabled">true</param>
+       <param id="docker_volumes">$defaults,/opt/Galaxy:/opt/Galaxy:ro </param>
      </destination> 
    #tools/bwa/bwa_mem.xml
      <requirements>
       <requirement type="package" version="0.7.9"> </requirement>
+      <container type="docker">ccc.docker/bwa</container>
      </requirements>
    #/tools/gatk/gatk2_macros.xml
       <requirement type="package" version="0.1.19">samtools</requirement>
       <requirement type="set_environment">GATK2_PATH</requirement>
       <requirement type="set_environment">GATK2_SITE_OPTIONS</requirement>
+      <container type="docker">ccc.docker/gatk</container>
     </requirements>


  ```
