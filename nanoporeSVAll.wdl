version 1.0
import "imports/pull_smkConfig.wdl" as smkConfig

workflow nanoporeSVAll {
    input {
        String sample
        String normal
        String tumor
        String samplefile
    }
    parameter_meta {
        sample: "name of sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file"
    }

    call smkConfig.smkConfig{
        input:
        sample=sample,
        normal = normal,
        tumor = tumor,
        samplefile = samplefile
    }

    call SVAll {
        input:
        config = smkConfig.config,
        sample = sample
    }

    output {
        File insertions = SVAll.insertions
        File deletions = SVAll.deletions 
        File duplications = SVAll.duplications
        File inversions = SVAll.inversions
        File translocations = SVAll.translocations
        File CNVs = SVAll.CNVs
        File depth100window = SVAll.depth100window
        File depth1000window = SVAll.depth1000window
        File depth10000window = SVAll.depth10000window
        File depth100000window = SVAll.depth100000window
        File depth500000window = SVAll.depth500000window
        File plotDepth = SVAll.plotDepth
        File plotSmall = SVAll.plotLarge
        File plotLarge = SVAll.plotLarge
        Array[File] plotDepthChrms = SVAll.plotDepthChrms
        }

    meta {
     author: "Gavin Peng"
     email: "gpeng@oicr.on.ca"
     description: "nanoporeSVAll, workflow that generates structural variant and coverage analysis files from input of nanopore fastq files, a wrapper of the workflow https://github.com/mike-molnar/nanopore-SV-analysis"
     dependencies: [
      {
        name: "nanopore_sv_analysis/20220505",
        url: "https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml"
      }
     ]
    output_meta: {
    insertions: {
        description: "output from rule all of the original workflow",
        vidarr_label: "insertions"
    },
    deletions: {
        description: "output from rule all of the original workflow",
        vidarr_label: "deletions"
    },
    duplications: {
        description: "output from rule all of the original workflow",
        vidarr_label: "duplications"
    },
    inversions: {
        description: "output from rule all of the original workflow",
        vidarr_label: "inversions"
    },
    translocations: {
        description: "output from rule all of the original workflow",
        vidarr_label: "translocations"
    },
    CNVs: {
        description: "output from rule all of the original workflow",
        vidarr_label: "CNVs"
    },
    depth100window: {
        description: "output from rule all of the original workflow",
        vidarr_label: "depth100window"
    },
    depth1000window: {
        description: "output from rule all of the original workflow",
        vidarr_label: "depth1000window"
    },
    depth10000window: {
        description: "output from rule all of the original workflow",
        vidarr_label: "depth10000window"
    },
    depth100000window: {
        description: "output from rule all of the original workflow",
        vidarr_label: "depth100000window"
    },
    depth500000window: {
        description: "output from rule all of the original workflow",
        vidarr_label: "depth500000window"
    },
    plotDepth: {
        description: "output from rule all of the original workflow",
        vidarr_label: "plotDepth"
    },
    plotSmall: {
        description: "output from rule all of the original workflow",
        vidarr_label: "plotSmall"
    },
    plotLarge: {
        description: "output from rule all of the original workflow",
        vidarr_label: "plotLarge"
    },
    plotDepthChrms: {
        description: "output from rule all of the original workflow",
        vidarr_label: "plotDepthChrms"
    }
}
    }
}

    # ============================================================
    # run the nanopore workflow for all structural variant analysis
    # ============================================================
    task SVAll {
        input {
        File config
        String sample 
        String modules
        Int jobMemory = 32
        Int timeout = 24
        }

        parameter_meta {
        jobMemory: "memory allocated for Job"
        modules: "Names and versions of modules"
        timeout: "Timeout in hours, needed to override imposed limits"
        }

        command <<<
        set -euo pipefail
        cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
        cp ~{config} .
        $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake --jobs 16 --rerun-incomplete --keep-going --latency-wait 60 --cluster "qsub -cwd -V -o snakemake.output.log -e snakemake.error.log  -P gsi -pe smp {threads} -l h_vmem={params.memory_per_thread} -l h_rt={params.run_time} -b y "
        >>> 

    runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
    }

    output {
    File insertions = "~{sample}/analysis/structural_variants/~{sample}.insertions.bed"
    File deletions = "~{sample}/analysis/structural_variants/~{sample}.deletions.bed"
    File duplications = "~{sample}/analysis/structural_variants/~{sample}.duplications.bed"
    File inversions = "~{sample}/analysis/structural_variants/~{sample}.inversions.bed"
    File translocations = "~{sample}/analysis/structural_variants/~{sample}.translocations.bedpe"
    File CNVs = "~{sample}/analysis/structural_variants/~{sample}.CNVs.bed"
    File depth100window = "~{sample}/analysis/coverage/samtools_depth/~{sample}.depth.100_window.bed"
    File depth1000window = "~{sample}/analysis/coverage/samtools_depth/~{sample}.depth.1000_window.bed"
    File depth10000window = "~{sample}/analysis/coverage/samtools_depth/~{sample}.depth.10000_window.bed"
    File depth100000window = "~{sample}/analysis/coverage/samtools_depth/~{sample}.depth.100000_window.bed"
    File depth500000window  = "~{sample}/analysis/coverage/samtools_depth/~{sample}.depth.500000_window.bed"
    File plotDepth = "~{sample}/analysis/coverage/plots/~{sample}/~{sample}.depth.pdf"
    File plotSmall = "~{sample}/analysis/coverage/plots/~{sample}/~{sample}.small_chr.pdf"
    File plotLarge = "~{sample}/analysis/coverage/plots/~{sample}/~{sample}.large_chr.pdf"
    Array[File] plotDepthChrms = glob("~{sample}/analysis/coverage/plots/~{sample}/~{sample}.depth.*.pdf")
    }
    }
