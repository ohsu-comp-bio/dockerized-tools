[**BWA Dockerfile**](#bwa-dockerfile)  

  Docker context
  ```
  bwa]$ ls -l
drwxr-xr-x 2 walshbr ohsu 4096 Jun 11 19:01 bwa-0.7.4
-rw-r--r-- 1 walshbr ohsu  194 Jun 11 19:15 Dockerfile
  ```
 

  ```bash
  # same as host-os
  FROM centos:6.6
  # for support
  MAINTAINER Intel CCC
  
  # assumes bwa-0.7.4 in current directory
  COPY bwa-0.7.4 /bwa-0.7.4/
  # set path for tool wrapper
  ENV PATH=/bwa-0.7.4:$PATH
  
  ```


[Galaxy Changes](#galaxy-changes)

  ```bash
    #job_conf.xml  
      <destination id="local" runner="local">
+       <param id="docker_enabled">true</param>
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
