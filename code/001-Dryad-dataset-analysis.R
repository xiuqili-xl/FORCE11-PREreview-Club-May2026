# Load libraries ----
library(tidyverse)
library(here)


# Data source ----
## Vinson, Valda; Kmec, Lauren (2025). Leveraging metrics to drive data sharing at the Science journals 
## [Dataset; License CC0 1.0]. Dryad. https://doi.org/10.5061/dryad.zkh1893qt



# Import data ----
article_data <- read_csv(here("data_Dryad", "AAAS_Open_Science_Metrics_data_2021_to_2024.csv"))
glimpse(article_data)

summary_stats <- read_csv(here("data_Dryad", "Summary_data_Science_and_comparators_.csv"))
glimpse(summary_stats)



# Sanity check ----
## meta data: "2680 Science papers published between 2021 and 2024"
nrow(article_data)
article_data %>% count(Publication_Year)

## articles should have distinct doi
length(unique(article_data$DOI))



# Data sharing ----
## metadata: "all papers had a data availability statement"
unique(article_data$DAS)
article_data %>% 
  count(DAS)


## metadata: "6% of papers did not generate or share data"
article_data %>% 
  count(Data_Generated, Data_Shared, name = "count") %>%
  mutate(percent = count / sum(count) * 100)


## logic: for article marked "Yes" under for Data_Generated, there should be 
## a corresponding "Data_Section_Text_Generated"
article_data %>%
  count(Data_Generated, Data_Section_Text_Generated)


## metadata: "69% of papers shared data in a repository, online, or in a supplementary data table"
article_data %>%
  count(Data_Shared, Data_Section_Text_Shared)

article_data %>%
  count(Data_Shared, Data_Location, name = "count") %>%
  mutate(percent = count / sum(count) * 100)


## logic: for articles that shared data online (i.e., "Online" under Data_Location), 
## there should be at least one entry under Data_Sharing_Accessions, Data_Sharing_URLs, or Data_Sharing_DOIs
article_data %>%
  select(DOI, starts_with("Data")) %>% 
  filter(str_detect(Data_Location, "Online")) %>%
  # it would be problematic if all three variables named above are empty
  mutate(Data_Online_Count = as.numeric(!is.na(Data_Sharing_Accessions)) + 
           as.numeric(!is.na(Data_Sharing_URLs)) + 
           as.numeric(!is.na(Data_Sharing_DOIs))) %>%
  filter(Data_Online_Count == 0) %>% 
  view()
# 90 entries that has the "Online" tag for Data_Location, but no Accessions, URLs, or DOIs


## metadata: "Online data includes data in repositories and articles sharing data 
## both online and in the supplementary material were classified as “Online”."
## Question: both articles are tagged "Online", "Suppl Material", both, or neither (NA)
## so this statement is kinda confusion


## logic (reverse): for articles without online sharing, there should not be an entry
article_data %>%
  select(DOI, starts_with("Data")) %>% 
  filter(!str_detect(Data_Location, "Online")) %>%
  # it would be problematic if the three variables are not empty bc that would mean data is shared online
  mutate(Data_Online_Count = as.numeric(!is.na(Data_Sharing_Accessions)) + 
           as.numeric(!is.na(Data_Sharing_URLs)) + 
           as.numeric(!is.na(Data_Sharing_DOIs))) %>% 
  filter(Data_Online_Count != 0) %>% 
  view()
# 1 article with NCBI accession, but only tagged as "Suppl Material" under Data_Location



# Code sharing ----
## metadata: "23% of papers shared code (46% of papers did not generate or share code)"
article_data %>%
  count(Code_Generated, Code_Shared, name = "count") %>%
  mutate(percent = count / sum(count) * 100)


## logic: if article generated code (i.e., Yes for Code_Generated), where this info 
## appears in the article should be noted (i.e., Code_Section_Text_Generated)
article_data %>%
  count(Code_Generated, Code_Section_Text_Generated)
  

## logic: if article shared code (i.e., Yes for Code_Shared), where this info 
## appears in the article should be noted (i.e., Code_Section_Text_Shared)
article_data %>%
  count(Code_Shared, Code_Section_Text_Shared)
## also uses the label MM = Materials and Methods?


## logic: if code is shared online, it should come with a URL or repository info
article_data %>%
  count(Code_Shared, Code_Location)
## no code shared via Suppl Material. Not surprising...

article_data %>% 
  select(DOI, starts_with("Code")) %>% 
  filter(str_detect(Code_Location, "Online")) %>%
  # it would be problematic if there is no URL or repository
  filter(is.na(Code_Sharing_URLs), is.na(Code_Sharing_Repositories)) %>% 
  view()
## 59 entries that has an "Online" tag for Code_Location, but no URL or Repositories listed
## note, there are also 43 entries that has an "Online" tag and Repository entry, but no URL



# Preprint data ----
## logic: if a preprint match was identified, there should at lease be an URL
article_data %>%
  count(Preprint_Match, name = "count") %>%
  mutate(percent = count / sum(count) * 100)

article_data %>%
  select(DOI, starts_with("Preprint")) %>%
  filter(Preprint_Match == "Yes", is.na("Preprint_URL")) 
## returned 0, as expected!  


## metadata: preprint posting data should be before journal publishing date 
article_data %>% 
  select(DOI, starts_with("Publication"), starts_with("Preprint")) %>%
  filter(Preprint_Match == "Yes") %>% 
  # there at least a year value for publication and preprint date
  # 2 publications are missing month and day data
  mutate(Publication_Date = case_when(is.na(Publication_Month) | is.na(Publication_Day) ~ paste(Publication_Year, "01-01", sep = "-"),
                                      TRUE ~ paste(Publication_Year, Publication_Month, Publication_Day, sep = "-")),
         Preprint_Date = case_when(is.na(Preprint_Month) | is.na(Preprint_Day) ~ paste(Preprint_Year, "01-01", sep = "-"),
                                   TRUE ~ paste(Preprint_Year, Preprint_Month, Preprint_Day, sep = "-")),
         Publication_Date = ymd(Publication_Date),
         Preprint_Date = ymd(Preprint_Date)) %>%
  mutate(Preprint_before_Publication = (Preprint_Date <= Publication_Date)) %>%
  count(Preprint_before_Publication)
## all true!     



# Summary data ----
view(summary_stats)

## Key stats relevant for this study
## (1) Science data sharing data overall: 1846 (69%)
article_data %>%
   count(Data_Generated, Data_Shared, name = "count") %>%
   mutate(percent = count / sum(count) * 100)
## 1846 (69%) sharing data overall: include both that generate data and that doesn't


## (2) Science sharing data in a repository: 1488 (56%)
article_data %>% 
  count(Data_Shared, Data_Location)
## Data shared online 986 + 739 = 1725, higher than data shared in a repository

article_data %>%
  mutate(Data_in_Repository = !is.na(Data_Sharing_Repositories)) %>%
  count(Data_in_Repository)
## this matches the 1488 in summary stats
## questions remain for the 90 entries that has the "Online" tag for Data_Location, but no Accessions, URLs, or DOIs

## also raises question about data online, but not in a repository
article_data %>%
  select(DOI, starts_with("Data")) %>%
  filter(str_detect(Data_Location, "Online"), is.na(Data_Sharing_Repositories)) %>%
  view()
## 238 of these


## (3) Science generating code: 1442
article_data %>%
  count(Code_Generated)
## matches the 1442 count reported in summary_stats


## (4) Science sharing generated code 594 (41%)
article_data %>%
  count(Code_Generated, Code_Shared, name = "count") %>%
  mutate(percent = count / sum(count) * 100)

article_data %>%
  count(Code_Generated, Code_Shared, name = "count") %>%
  group_by(Code_Generated) %>%
  mutate(percent = count / sum(count) * 100) %>%
  ungroup()
# matches 594 count; 41% is based on calculation of those that generated code



# From FORCE11 live review discussion ----
## regional bias
article_data %>%
  count(First_Author_Country) %>%
  arrange(desc(n))

## sudden jump in percent article that generate data between 2022 and 2023
article_data %>%
  count(Publication_Year, Data_Generated) %>%
  group_by(Publication_Year) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(Data_Generated == "Yes")

## check Data_Shared --- steady increase
article_data %>%
  count(Publication_Year, Data_Shared) %>%
  group_by(Publication_Year) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(Data_Shared == "Yes")

## check Code_Generated --- relatively steady increase
article_data %>%
  count(Publication_Year, Code_Generated) %>%
  group_by(Publication_Year) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(Code_Generated == "Yes")

## check Code_Shared / Code_Generated --- relatively stable around 40%
article_data %>%
  count(Publication_Year, Code_Generated, Code_Shared) %>%
  group_by(Publication_Year, Code_Generated) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(Code_Generated == "Yes", Code_Shared == "Yes")
