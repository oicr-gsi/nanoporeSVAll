# nanoporeSVAll

nanoporeSVAll, workflow that generates structural variant and coverage analysis files from input of nanopore fastq files, a wrapper of the workflow https://github.com/mike-molnar/nanopore-SV-analysis

## Overview

## Dependencies

* [nanopore_sv_analysis 20220505](https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml)


## Usage

### Cromwell
```
java -jar cromwell.jar run nanoporeSVAll.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`sample`|String|name of sample
`normal`|String|name of the normal sample
`tumor`|String|name of the tumor sample
`samplefile`|String|sample file
`smkConfig.generateConfig_modules`|String|modules needed to run generateConfig
`SVAll.modules`|String|Names and versions of modules


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`smkConfig.generateConfig_timeout`|Int|24|Timeout in hours, needed to override imposed limits
`smkConfig.generateConfig_jobMemory`|Int|8|memory allocated for Job
`SVAll.jobMemory`|Int|32|memory allocated for Job
`SVAll.timeout`|Int|24|Timeout in hours, needed to override imposed limits


### Outputs

Output | Type | Description | Labels
---|---|---|---
`insertions`|File|output from rule all of the original workflow|vidarr_label: insertions
`deletions`|File|output from rule all of the original workflow|vidarr_label: deletions
`duplications`|File|output from rule all of the original workflow|vidarr_label: duplications
`inversions`|File|output from rule all of the original workflow|vidarr_label: inversions
`translocations`|File|output from rule all of the original workflow|vidarr_label: translocations
`CNVs`|File|output from rule all of the original workflow|vidarr_label: CNVs
`depth100window`|File|output from rule all of the original workflow|vidarr_label: depth100window
`depth1000window`|File|output from rule all of the original workflow|vidarr_label: depth1000window
`depth10000window`|File|output from rule all of the original workflow|vidarr_label: depth10000window
`depth100000window`|File|output from rule all of the original workflow|vidarr_label: depth100000window
`depth500000window`|File|output from rule all of the original workflow|vidarr_label: depth500000window
`plotDepth`|File|output from rule all of the original workflow|vidarr_label: plotDepth
`plotSmall`|File|output from rule all of the original workflow|vidarr_label: plotSmall
`plotLarge`|File|output from rule all of the original workflow|vidarr_label: plotLarge
`plotDepthChrms`|Array[File]|output from rule all of the original workflow|vidarr_label: plotDepthChrms


## Commands
This section lists command(s) run by nanoporesvall workflow
 
* Running nanoporesvall
 
 
```
         set -euo pipefail
         cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
         cp ~{config} .
         $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake --jobs 16 --rerun-incomplete --keep-going --latency-wait 60 --cluster "qsub -cwd -V -o snakemake.output.log -e snakemake.error.log  -P gsi -pe smp {threads} -l h_vmem={params.memory_per_thread} -l h_rt={params.run_time} -b y "
```
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
