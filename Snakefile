import os
from pathlib import Path
from glob import glob
from numpy import unique

configfile: 'configs/DDR_titration_series.yaml'
samples = glob(os.path.join(config['tiff_dir'],'*_IA.tiff'))
samples = [Path(s).stem.split('.tif')[0] for s in samples]

## 
rule all: 
   input: expand(os.path.join(config['mask_dir'], "{s}_mask.tiff"), s=samples)

rule segment:
   # see harrig12 fork of https://github.com/camlab-bioml/2021_DeepCellIMCPipeline
   conda: "deepcell"
   params:
       microns_per_pixel=config['microns_per_pixel'],
       arcsinh_normalize=config['arcsinh'],
       arcsinh_cofactor=config['cofactor'],
   input:
       tiff=config['tiff_dir'] + "{sample}.tiff",
       channel_names=config['channel_names'],
       channel_info=config['channel_info'],
   output:
       mask=config['mask_dir'] + "{sample}_mask.tiff"
   shell:
       "python 2021_DeepCellIMCPipeline/pipeline/run_deepcell.py "
       "--input_tiff {input.tiff} "
       "--input_channel_names {input.channel_names} "
       "--input_channel_info {input.channel_info} "
       "--microns_per_pixel {params.microns_per_pixel} "
       "--arcsinh_normalize {params.arcsinh_normalize} "
       "--arcsinh_cofactor {params.arcsinh_cofactor} "
       "--output_mask {output.mask} "

#rule segment:
#   input: expand(os.path.join(config['tiff_dir'], "{s}_{type}.tiff"), s=samples, type=["IA", "full"])
#   output: expand(os.path.join(config['mask_dir'], "{s}_mask.tiff"), s=samples)
#   conda: "deepcell"
#   shell: "echo foo"

    