# FORCE11 PREreview Club May 2026

This repository contains review-supporting code and source data used to examine the Dryad dataset:

> Vinson, Valda; Kmec, Lauren (2025). *Leveraging metrics to drive data sharing at the Science journals* [Dataset; CC0 1.0]. Dryad.
> <https://doi.org/10.5061/dryad.zkh1893qt>

This dataset review was completed as part of the [FORCE11 PREreview Club](https://prereview.org/clubs/force11) and is intended for sharing on PREreview.

Final dataset review: forthcoming


## Repository Structure

```text
.
├── code/                                                   # R script used to examine and review the datasets
│   └── 001-Dryad-dataset-analysis.R          
│   └── 002-Comparison-dataset-analysis.R      
│   └── 003-analysis-post-live-review.R      
├── data_comparison/                                        # Comparison datasets downloaded directly from Figshare
│   └── PLOS_Dataset_v10_Jul25.csv
│   └── PLOS_OSI_Summary-statistics_v10_Jul25.xlsx
│   └── PLOS_OSI-Column-Descriptions_v5_Jul25.pdf
│   └── PLOS_OSI-Methods-Statement_v10_Jul25.pdf
│   └── T&F Open Science Metrics Dataset_FINAL_PUBLIC.xlsx
├── data_Dryad/                                             # Dataset files downloaded directly from Dryad
│   └── AAAS_Open_Science_Metrics_data_2021_to_2024.csv
│   └── Summary_data_Science_and_comparators_.csv
├── data_OpenAlex/                                          # Dataset pulled from OpenAlex
│   └── science_openalex_2021-2024.csv
├── .gitignore
├── LICENSE
├── README.md
└── Vinson Dyrad 2025.Rproj                                 # RStudio project file
```


## Code

The analysis scripts in `code/` were written to **support the dataset review**. They are exploratory review-supporting scripts rather than a polished reproducible research pipeline.

* `001-Dryad-dataset-analysis.R` checks selected claims from the [Dryad dataset](https://doi.org/10.5061/dryad.zkh1893qt) metadata and explores internal consistency between variables.
* `002-Comparison-dataset-check.R` compares selected Science metrics against those of [PLOS](https://doi.org/10.6084/m9.figshare.21687686.v10) and [Taylor & Francis](https://doi.org/10.6084/m9.figshare.30316342) as reported by Vinson and Kmec.
* `003-analysis-post-live-review.R` contains additional analyses completed during or after the FORCE11 live review discussion (May 22, 2026), including checks related to author country, year-to-year patterns, and comparison with OpenAlex data.

Some scripts include interactive inspection steps such as `view()`. These are intended for manual review and may not run as a fully automated workflow from beginning to end.



## Data Sources

### Dryad Data

The files in `data_Dryad/` were downloaded directly from the following Dryad deposit *without modifications*:

> Vinson, Valda; Kmec, Lauren (2025). *Leveraging metrics to drive data sharing at the Science journals* [Dataset; License CC0 1.0]. Dryad.
> <https://doi.org/10.5061/dryad.zkh1893qt>


### Comparison Data

The files in `data_comparison/` were downloaded directly from the following Figshare data deposits *without modifications*:

> Public Library of Science (2025). *PLOS Open Science Indicators.* [Dataset; License CC BY 4.0]. 
> PLOS Figshare. <https://doi.org/10.6084/m9.figshare.21687686.v10>

> Taylor-Grant, Rebecca; Norris, Eilise (2025). *Open Science Indicators for a corpus of 8,131 research articles published by Taylor & Francis journals.* 
> [Dataset; License CC BY 4.0]. Figshare. <https://doi.org/10.6084/m9.figshare.30316342>


### OpenAlex Data

The csv file in `data_OpenAlex/` was generated using code in `code/003-analysis-post-live-review.R` and contains data obtained from OpenAlex on May 22, 2026.

Because OpenAlex records are updated over time, `data_OpenAlex/science_openalex_2021-2024.csv` should be treated as a **saved snapshot**. Regenerating this file requires an OpenAlex API key and may produce different results depending on when the query is run.

The saved OpenAlex file includes article DOI (`doi`), OpenAlex article ID (`article_id`), article type (`article_type`), publication date (`publication_date`), open access status fields (`oa_is_oa`, `oa_status`, and `oa_fulltext`), and an indicator for whether the DOI appears in the Vinson and Kmec Dryad dataset (`in_vinson`).



## Analysis Notes

This repository was created to **support a dataset review**, not to provide a definitive reanalysis of the source datasets.

Several points should be kept in mind when interpreting the code and outputs:

* The scripts were written for rapid review and exploratory checking
* Some outputs are inspected in the R console or viewer rather than saved as separate result files
* Source datasets contain additional metadata that were referenced during the analysis, but are not captured in this repository
* OpenAlex data may change over time, so regenerated results may differ from the saved snapshot

**Please cite the original datasets directly when reusing or discussing the data.**



## AI Coding Agent Use

Generative AI (Codex, GPT-5.5, Medium Intelligence) was **only** used to draft this `README.md` file, which has since been reviewed and edited to ensure accuracy.


