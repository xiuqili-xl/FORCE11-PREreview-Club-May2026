# FORCE11 PREreview Club May 2026

This repository contains code and source data used to support a review of the Dryad dataset:

> Vinson, Valda; Kmec, Lauren (2025). *Leveraging metrics to drive data sharing at the Science journals* [Dataset; License CC0 1.0]. Dryad.
> <https://doi.org/10.5061/dryad.zkh1893qt>

This dataset review was completed as part of the [FORCE11 PREreview Club](https://prereview.org/clubs/force11) and is intended for sharing on PREreview.

Link of final dataset review: forthcoming


## Repository structure and content

```text
.
├── code/                                                   # R script used to examine and review the dataset
│   └── 001-Dryad-dataset-analysis.R          
│   └── 002-Comparison-dataset-analysis.R          
├── data_comparison/                                        # Dataset files downloaded directly from Figshare
│   └── PLOS_Dataset_v10_Jul25.csv
│   └── PLOS_OSI_Summary-statistics_v10_Jul25.xlsx
│   └── PLOS_OSI-Column-Descriptions_v5_Jul25.pdf
│   └── PLOS_OSI-Methods-Statement_v10_Jul25.pdf
│   └── T&F Open Science Metrics Dataset_FINAL_PUBLIC.xlsx
├── data_Dryad/                                             # Dataset files downloaded directly from Dryad
│   └── AAAS_Open_Science_Metrics_data_2021_to_2024.csv
│   └── Summary_data_Science_and_comparators_.csv
├── .gitignore
├── LICENSE
├── README.md
└── Vinson Dyrad 2025.Rproj                                 # RStudio project file
```


## Analysis notes

### Code

The analysis script was used to inspect the Dryad dataset during review. It includes checks of selected statements from the dataset metadata (i.e., key findings) and internal consistency between variables.

**The script was written for speed** during the review process, not as a fully reproducible research workflow. It should be read as review-supporting code rather than a polished analysis pipeline.

### Data

The files in `data_Dryad/` were downloaded directly from the following Dryad deposit (no modifications):

> Vinson, Valda; Kmec, Lauren (2025). *Leveraging metrics to drive data sharing at the Science journals* [Dataset; License CC0 1.0]. Dryad.
> <https://doi.org/10.5061/dryad.zkh1893qt>

The files in `data_comparison/` were downloaded directly from the following Figshare data deposits (no modifications):

> Public Library of Science (2025). *PLOS Open Science Indicators.* [Dataset; License CC BY 4.0]. 
> PLOS Figshare. <https://doi.org/10.6084/m9.figshare.21687686.v10>

> Taylor-Grant, Rebecca; Norris, Eilise (2025). *Open Science Indicators for a corpus of 8,131 research articles published by Taylor & Francis journals.* 
> [Dataset; License CC BY 4.0]. Figshare.
> <https://doi.org/10.5061/dryad.zkh1893qt>

For detailed descriptions of the original projects and metadata, please refer to the documentation each dataset.

**Please cite the original datasets directly when reusing or discussing the data.**

