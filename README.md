# FORCE11 PREreview Club May 2026

This repository contains code and source data used to support a review of the Dryad dataset:

> Vinson, Valda; Kmec, Lauren (2025). *Leveraging metrics to drive data sharing at the Science journals* [Dataset]. Dryad.
> <https://doi.org/10.5061/dryad.zkh1893qt>

This dataset review was completed as part of the [FORCE11 PREreview Club](https://prereview.org/clubs/force11) and is intended for sharing on PREreview.

Link of final dataset review: forthcoming


## Repository structure and content

```text
.
├── .gitignore
├── code/                                     # R script used to examine and review the dataset
│   └── 001-Dryad-dataset-analysis.R          
├── data_Dryad/                               # Dataset files downloaded directly from Dryad
│   └── AAAS_Open_Science_Metrics_data_2021_to_2024.csv
│   └── Summary_data_Science_and_comparators_.csv
├── LICENSE
├── README.md
└── Vinson Dyrad 2025.Rproj                       # RStudio project file
```


## Analysis notes

## Code

The analysis script was used to inspect the Dryad dataset during review. It includes checks of selected statements from the dataset metadata and internal consistency around data sharing, code sharing, preprint information, and summary statistics.

The script was written for speed during the review process, not as a fully reproducible research workflow. It should be read as review-supporting code rather than a polished analysis pipeline.

## Data

The files in `data_Dryad/` were downloaded directly from the Dryad deposit cited above (no modifications):

- `AAAS_Open_Science_Metrics_data_2021_to_2024.csv`
- `Summary_data_Science_and_comparators_.csv`

Please cite the [Dryad dataset](https://doi.org/10.5061/dryad.zkh1893qt) directly when reusing or discussing the data.

