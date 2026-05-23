# Load libraries ----
library(tidyverse)
library(readxl)
library(here)

# Import data ----
plos_data <- read_csv(here("data_comparison", "PLOS_Dataset_v10_Jul25.csv"))
glimpse(plos_data)

tf_data <- read_xlsx(here("data_comparison", "T&F Open Science Metrics Dataset_FINAL_PUBLIC.xlsx"),
                     sheet = "FullDataset", .name_repair = "universal")
glimpse(tf_data)



# PLOS dataset ----

## RE PLOS dataset used for analysis ----
## Vinson summary_data csv: "PLOS No. of publications: 138995"

nrow(plos_data)
length(unique(plos_data$DOI))
## matches 138995 reported by Vinson. So looks like they included the entire dataset
## also matches the Summary-statistics file of the PLOS dataset


## Publication_Year
plos_data %>%
  count(Publication_Year)
## ranges from 2018 - 2025
## matches that in the Summary-statistics file of the PLOS dataset


## Data_Location
plos_data %>%
  count(Data_Shared, Data_Location)


## Repositories_data
plos_data %>%
  mutate(Repository_Named = (!is.na(Repositories_data))) %>%
  count(Data_Shared, Repository_Named)
## 437 + 35570 = 36007
## PLOS Summary-statistics and Vinson reporting counts all article that identified a repository, 
## including those Data_Share == FALSE



## RE overall data sharing ----
## Vinson Dryad README: "Overall data sharing was [...] 74% for PLOS [...],
plos_data %>% 
  count(Data_Shared) %>%
  mutate(percent = n / sum(n) * 100)
## so... 102866 and 74% matches that reported by Vinson et al
## but this stat is for all PLOS papers in this dataset (i.e., between 2018 - 2025)

## if we limit to just 2021 to 2024 to match Vinson analysis
plos_data %>% 
  filter(Publication_Year >= 2021, Publication_Year <= 2024) %>%
  count(Data_Shared) %>%
  mutate(percent = n / sum(n) * 100)
## percent data shared rises to 75%



## RE data sharing in a repository ----
## Vinson Dryad README: "data shared in a repository was [...] 26% for PLOS. [...]
plos_data  %>%
  mutate(Repository_Named = (!is.na(Repositories_data))) %>%
  count(Repository_Named) %>%
  mutate(percent = n / sum(n) * 100)
## 36007 and 25.9% matches that reported by Vinson et al
## including those that has Data_Share == FALSE for some of these articles???

## restricting to just 2021-2024...
plos_data  %>%
  mutate(Repository_Named = (!is.na(Repositories_data))) %>%
  filter(Publication_Year >= 2021, Publication_Year <= 2024) %>%
  count(Repository_Named) %>%
  mutate(percent = n / sum(n) * 100)
## percent data sharing in repository rises to 28.6%

## another question: does the two dataset use the same criteria for repository inclusion?
## this would take additional investigation...



## RE code sharing for papers that generated code ----
## Vinson Dryad README: "For the papers that generated code, code sharing was [...] 29% for PLOS"
plos_data %>%
  count(Code_Generated, Code_Shared) %>%
  group_by(Code_Generated) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup()
# 15154 + 36886 = 52040
## 15154 out of 52040 and 29.1% matches that reported by Vinson et al


## restricting to just 2021-2024
plos_data %>%
  filter(Publication_Year >= 2021, Publication_Year <= 2024) %>%
  count(Code_Generated, Code_Shared) %>%
  group_by(Code_Generated) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup()
## percent of code sharing for papers that generate code goes up to 32.9%




# Taylor & Francis dataset ----

## RE T&F dataset used for analysis ----
## Vinson summary_data csv: "T&F No. of publications: 8231"
nrow(tf_data)
length(unique(tf_data$DOI))
## 8131. Typo in data_Dryad/Summary_data_Science_and_comparisons_.csv file


## Publication.Year
tf_data %>%
  count(Publication.Year) %>%
  mutate(percent = n / sum(n) * 100)
## this ranges between 2020 to 2023. 
## but mostly 2023, accounting for 82.8% of the article in the dataset



## RE data shared ----
## Vinson Dryad README: "Overall data sharing was [...] 24% for T&F [...],
tf_data %>%
  count(Data_Shared) %>%
  mutate(percent = n / sum(n) * 100)
## 2016 and 24.6% -- close to Vinson reporting, but not exact...


## RE data shared in repository ----
## Vinson Dryad README: "data shared in a repository was [...] 11% for T&F. [...]
tf_data %>%
  mutate(Data_Repositories = if_else(Data_Repositories == "NA", NA, Data_Repositories),
         Data_in_Repository = (!is.na(Data_Repositories))) %>%
  count(Data_in_Repository) %>% 
  mutate(percent = n / sum(n) * 100)
## 890 and 10.9% -- close to Vinson reporting, but not exact...


## RE Code_Shared / Code_Generated ----
## Vinson Dryad README: "For the papers that generated code, code sharing was [...] 8% for T&F
tf_data %>%
  count(Code_Generated, Code_Shared) %>% 
  group_by(Code_Generated) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup()
## 155 + 1761 = 1916
## 155 / 1916 and 8.09% -- close to Vinson reporting, but not exact...


