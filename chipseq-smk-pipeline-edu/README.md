# Into

A simple pipeline for educational purposes. The pipeline:
* aligns Chip-Seq single-end data
* generates reads coverage track

Peak calling step is missing on purposed and is supposed to be a simple exercise.

# Configure Pipeline
```shell
git clone https://github.com/JetBrains-Research/chipseq-smk-pipeline-edu#configure-pipeline <pipeline_working_dir>

cd <pipeline_working_dir>
```

Pipeline is tested with snakemake 6.3.0. It is recommended to create a fresh conda environment using `mamba` or `conda` (see https://snakemake.readthedocs.io/en/stable/getting_started/installation.html?highlight=mamba#installation-via-conda-mamba)
:
```shell
mamba env create --name snakemake --file ./environment.yaml
# or:
# conda env create --name snakemake --file ./environment.yaml
```
Activate conda environment with snakemake:
```shell
conda activate snakemake
```


**Configure input data**:
Download and unpack [example data](https://drive.google.com/file/d/1vtHVs4Yvf6ZnfynllxGYD7Lc96HuU46m/view?usp=sharing).
Copy `reads` folder to working directory. Delete `data_table.tsv` because `config` folder already has more recent version of `data_table.csv`.

# Run

Plot DAG and rule graphs
```shell
snakemake --dag | dot -Tsvg > images/dag.svg
snakemake --rulegraph | dot -Tsvg > images/rulegraph.svg
```

Check pipeline
```shell
snakemake -pr --use-conda --cores 8 --dry-run
```

Run pipeline
```shell
snakemake -pr --use-conda --cores 8

# or:
#snakemake -pr --use-conda --cores 8 --notemp
```

Archive pipeline results to a bundle
```shell
snakemake -pr --use-conda --cores 1 all_results_bundle
```

Some clusters automatically clean files older than 1 month. You could ask snakemake
touch all files in a correct pipeline-specific order. At the moment it doesn't work
with outputs marked as `temp(..)`:
```shell
snakemake --cores 8 --use-conda --touch --forceall
```