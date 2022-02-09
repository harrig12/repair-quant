# Conda environments

Env files that reproduce the conda environments used in development. These create the named environments expected by Snakemake. If you rename these, you should also modify the snakefile. Run `conda env create -f <filename>.yaml` to install. 

## Note on R
Conda doesn't provide every package in R, so there are some packages that still have to be install manually, namely cytomapper. `cytomapper_dev.yml` prepares an env that has everything needed to install cytomapper successfully, after which running the following will resolve the remaining dependencies:

```
conda activate cytomapper
Rscript -e "BiocManager::install("cytomapper")"
```
