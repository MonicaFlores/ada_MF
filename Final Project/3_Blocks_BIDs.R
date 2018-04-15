#Import dataset GIS union between BIDs and Census Tracts. Keep one CT observation.
#Choose the biggest portion of the CT if it falls within many BIDs.

# pkgs <- c("haven", "tidyverse", "stringr", "glue", "dplyr", "foreign", "WriteXLS", "lubridate")
# install.packages(pkgs)


library(tidyverse)
library(stringr)
library(glue)
library(dplyr)
library(haven)
library(foreign)
library(WriteXLS)
library (lubridate)

data_dir <- "/Users/MoniFlores/Desktop/NYU 4th semester/Data Analysis for Public Policy/Census Block Data"

#Import joined data from GIS
raw<- glue("{data_dir}/raw_BlockData_2.xlsx") %>% 
  readxl::read_xlsx(col_types=c("text", "guess", "guess", "guess", 
                                "guess", "guess", "guess", "guess", "guess", 
                                "guess", "guess", "guess", "guess", "guess", "guess", 
                                "guess", "guess", "guess", "guess", "guess", "guess", 
                                "guess", "guess", "guess", "text", "text", "numeric")) %>% as_tibble()

#Clean data
clean <- raw %>%
  mutate(
    a_weight=(A_poly/blckArea_ft)
  ) %>% 
  group_by(BLOCKID) %>% 
  mutate(
    max_a=max(a_weight),
    BID_dummy = case_when(
      is.na(bid_id)  ~ 0,  
      TRUE ~ 1
    )
  ) %>% 
  filter(a_weight==max_a) %>% 
  ungroup() %>% 
  select(-max_a)

#Export full CT file
exp_path2<- glue("{data_dir}/CLEAN/Blocks_Full.csv") 
clean %>% write.csv(exp_path2, na="")