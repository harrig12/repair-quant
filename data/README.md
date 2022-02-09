# IMC data

```
./data
├── DDR_titration               # Source: CL (toronto onedrive)
│   ├── config
|   │   └── Panel.csv           # List of tags and protiens
│   ├── cpout                   
|   │   ├── *_IA_mask.tiff      # Image mask
|   |   └── *.csv               # CellProfiler quantification
|   ├── DeepCell                  
|   │   ├── masks               # Source: CH (generated with camlab DeepCell pipeline)
|   |   │   └── *_IA_mask.tiff  # Image mask 
|   │   ├── channel_data.yml    # Input file for DeepCell
|   |   └── channle_names.txt   # Input file for DeepCell
│   ├── tiffs  
|   │   ├── *.csv               # List of 21 channel names 
|   │   ├── *_full.tiff         # 21-channel tiff of panel
|   │   └── *_IA.tiff           # 3-channel tiff of background (0), nuclear markers (1), membrane markers (2)
├── IF+IMC_IF               # Source: CL (lunenfeld onedrive)
└── IF+IMC_IMC              # Source: CL (lunenfeld onedrive)
```
