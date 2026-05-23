# Load libraries ----
library(tidyverse)
library(here)


# Goal ---- 
## The following analysis was completed during/after the FORCE11 live review discussion
## This script explores some of the topics raised during the live discussion



# Regional bias of the dataset ----
article_data %>%
  count(First_Author_Country) %>%
  arrange(desc(n))
## top 10 countries are US, China, Germany, UK, Switzerland, 
## France, Japan, Canada, Australia, and Israel



# Difference in article characteristics between 2021/2022 and 2023/2024 ----
## Matt raised the issue of sudden jump in % article that generated data between 2022 and 2023
article_data %>%
  count(Publication_Year, Data_Generated) %>%
  group_by(Publication_Year) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(Data_Generated == "Yes")
## percent of article that generated data went from ~75% in 2021/2022 to over 95% in 2023/2024


## check Data_Shared --- steady increase from 66% to 72%
article_data %>%
  count(Publication_Year, Data_Shared) %>%
  group_by(Publication_Year) %>%
  mutate(percent = n / sum(n) * 100) %>%
  ungroup() %>%
  filter(Data_Shared == "Yes")


## check Code_Generated --- relatively steady increase from 50% to 58%
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


## explore publication per month
article_data %>%
  filter(!is.na(Publication_Month)) %>%           # 6 articles without Publication_Month
  count(Publication_Year, Publication_Month) %>%
  mutate(Publication_Month = month.abb[Publication_Month],
         Publication_Month = factor(Publication_Month, levels = month.abb),
         Publication_Year = as.character(Publication_Year)) %>%
  ggplot(mapping = aes(x = Publication_Month, y = n, 
                       group = Publication_Year, color = Publication_Year)) +
  geom_line() +
  theme_bw() +
  labs(title = "Number of publications per month", 
       x= "", y = "no of publications", color = "Year")
## number of publications from 2023 seems to be a little lower,
## not sure if that's something to be concerned about though...



# Comparison to OpenAlex ----

## check doi prefix of articles in Vinson et al
## since all articles came from Science, they should have the same doi prefix "10.1126/science"
article_data %>%
  mutate(DOI_Prefix_Check = str_detect(DOI, "10.1126/science"),, .after = DOI) %>%
  count(DOI_Prefix_Check)
## confirmed!


## pull data from OpenAlex
library(openalexR)
library(listviewer)
library(purrr)


## OpenAlex now requires an API key: https://docs.ropensci.org/openalexR/
## Replace "ADD KEY" below with actual API key. Remember to rotate API key regularly!
oa_api_key <- "ADD KEY"

science_oa_data <- oa_fetch(
  entity = "works",
  doi_starts_with = "10.1126/science",
  from_publication_date = "2021-01-01",
  to_publication_date = "2024-12-31",
  options = list(
    select = c("id", "doi", "type", "publication_date", "open_access")
  ),
  output = "list",
  api_key = oa_api_key
)


## explore output
jsonedit(number_unnamed(science_oa_data))


## turn into df
science_oa_df <- map_dfr(science_oa_data, ~tibble(
  doi              = pluck(.x, "doi", .default = NA_character_),
  article_id       = pluck(.x, "id", .default = NA_character_),
  article_type     = pluck(.x, "type", .default = NA_character_),
  publication_date = pluck(.x, "publication_date", .default = NA_character_),
  oa_is_oa         = pluck(.x, "open_access", "is_oa", .default = NA_character_),
  oa_status        = pluck(.x, "open_access", "oa_status", .default = NA_character_),
  oa_fulltext      = pluck(.x, "open_access", "any_repository_has_fulltext")
)) %>%
  mutate(doi = str_remove(doi, "https://doi.org/"),
         article_id = str_remove(article_id, "ttps://openalex.org/"))


## save a copy of this df, bc OpenAlex data gets updated regularly
write_csv(science_oa_df, here("data_OpenAlex", "science_openalex_2021-2024.csv"))



## Publication across the years ----
science_oa_df %>%
  mutate(publication_year = year(ymd(publication_date))) %>%
  count(publication_year, article_type) %>%
  ggplot(mapping = aes(x = publication_year, y = n, fill = article_type)) +
  geom_col() +
  labs(title = "Number of publications in Science",
       x = "", y = "no of articles", fill = "Type")

## note, number of articles in Vinson dataset
## 2021 - 708; 2022 - 664; 2023 - 581; 2024 - 727


## compare OpenAlex and Vinson dataset
science_oa_df %>%
  mutate(in_vinson = (doi %in% article_data$DOI)) %>%
  count(in_vinson, article_type) %>%
  ## data in Vinson et al are mostly tagged as article in OpenAlex 
  ## (a couple are tagged as editorial, preprint, review)
  filter(article_type %in% c("article", "editorial", "preprint", "review")) %>%
  select(article_type, in_vinson, n) %>%
  arrange(article_type, desc(in_vinson))


## spot check a couple
### (1) article in OpenAlex, but not in Vinson et al -- 5,245 entries
science_oa_df %>%
  mutate(in_vinson = (doi %in% article_data$DOI)) %>%
  filter(article_type == "article", in_vinson == FALSE) %>%
  view()
### 10.1126/science.abq1757 --- perspective
### 10.1126/science.add3748 --- news
### 10.1126/science.adf8746 --- Science Advisor piece
### 10.1126/science.abg9084 --- news
### 10.1126/science.abi5742 --- news


### (2) preprints according to OpenAlex and included in Vinson et al -- 20 entries
science_oa_df %>%
  mutate(in_vinson = (doi %in% article_data$DOI)) %>%
  filter(article_type == "preprint", in_vinson == TRUE) %>%
  view()
### 10.1126/science.abl5818 --- report
### 10.1126/science.abg8794 --- report
### 10.1126/science.abi6153 --- report


### (3) review according to OpenAlex and included in Vinson et al -- 5 entries
science_oa_df %>%
  mutate(in_vinson = (doi %in% article_data$DOI)) %>%
  filter(article_type == "review", in_vinson == TRUE) %>%
  view()
### 10.1126/science.adj6598 --- research article
### 10.1126/science.adp4461 --- research article
### 10.1126/science.ado1464 --- research article