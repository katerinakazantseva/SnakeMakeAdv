# Let's move some technical steps to common.smk just to make Snakefile short and clean
# E.g.: Load samples data table, configure config file path
include: "rules/common.smk"

# Steps that check RAW reads QC metrics
include: "rules/reads_qc.smk"
# Steps that download reference genome and build bowtie2 indexes
include: "rules/indexes.smk"
# Steps that align fastq files reads and check QC
include: "rules/align_reads.smk"
# Steps that build reads coverage tracks for raw signal visualization
include: "rules/coverage_track.smk"
# TODO: MACS2 steps
#include: "rules/bam_sort.smk"

# 'first' rule in file, which is executed by default
rule all:
    input:
        # Reads MultiQC report
        rules.reads_multiqc.output,

        # Reads FASTQC reports for all samples
        expand(
            #rules.reads_fastqc.output.html,
            "results/macs2/{sample}_{genome}_peaks.narrowPeak",
            sample=SAMPLES_DF.index,
            genome=config['genome']
  ),

        # Reads coverage tracks for each sample
        expand(
            rules.bam_bigwig.output,
            genome=config['genome'],
            sample=SAMPLES_DF.index
        )

        # TODO: MACS2 *.narrowPeak peaks

rule all_results_bundle:
    input: rules.all.input
    output: "chip_seq_results.tar.gz"
    shell: "tar -czvf {output} {input} logs benchmarks images"


rule callpeak:
    input:
        #rules.bam_sort.output
        treatment="results/bams_sorted/{sample}_{genome}.sorted.bam"
    output:
        multiext("results/macs2/{sample}_{genome}",
                 "_peaks.xls",
                 "_peaks.narrowPeak",
                 "_summits.bed"
                 )
    log:
        "logs/macs2/{sample}_{genome}_callpeak.log"
    params:
        "-f BAM -g hs"
    wrapper:
        "0.74.0/bio/macs2/callpeak"