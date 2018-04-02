#Import HH data from American Fact Finder. 
#For 2000 using Census Data, for  2010 and 2015 using ACS 5 yr estimate.

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

data_dir <-"/Users/MoniFlores/Desktop/NYU 4th semester/Data Analysis for Public Policy/HH/Demand"
#Data suffix
suffix <- "_with_ann.csv"
#Data prefix by year/dataset
y_15 <- "ACS_15_5YR_"
y_10 <- "ACS_10_5YR_"
y_00 <- "DEC_00_SF3_"

#Table names by datatype. ACS fist, then Census.

#Gross Rent (household)
#B25064
#H063
rent_15<- glue("{data_dir}/01_median_gross_rent_all/{y_15}B25064{suffix}") %>% 
  read.csv(na="-") %>% as_tibble() %>%  rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         med_rent_15=as.numeric(as.character(hd01_vd01))
  ) %>% select(CT_id_full, med_rent_15)
    
rent_10<- glue("{data_dir}/01_median_gross_rent_all/{y_10}B25064{suffix}") %>% 
  read.csv(na="-") %>% as_tibble()%>%  rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         #Adjust for inflation 2015 dollars
         med_rent_10nad=as.numeric(as.character(hd01_vd01)),
         med_rent_10=med_rent_10nad/0.92
  ) %>% select(CT_id_full, med_rent_10)

rent_00<- glue("{data_dir}/01_median_gross_rent_all/{y_00}H063{suffix}") %>% 
  read.csv(na="0") %>% as_tibble()%>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         #Adjust for inflation 2015 dollars
         med_rent_00nad=as.numeric(as.character(vd01)),
         med_rent_00=med_rent_00nad/0.73
  ) %>% select(CT_id_full, med_rent_00)

#HH income by tenure (household)
#B25119
#HCT012
hhinc_15<- glue("{data_dir}/02_median_hh_inc_tenure/{y_15}B25119{suffix}") %>% 
  read.csv(na="-") %>% as_tibble() %>% rename_all(tolower)%>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         hhinc_all_15 = as.numeric(as.character(hd01_vd02)),
         hhinc_owners_15 = as.numeric(as.character(hd01_vd03)),
         hhinc_renters_15 = as.numeric(as.character(hd01_vd04))
         )%>% 
  select(CT_id_full, hhinc_all_15, hhinc_owners_15, hhinc_renters_15)

hhinc_10<- glue("{data_dir}/02_median_hh_inc_tenure/{y_10}B25119{suffix}") %>% 
  read.csv(na="-") %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         hhinc_all_10_nad = as.numeric(as.character(hd01_vd02)),
         hhinc_owners_10_nad = as.numeric(as.character(hd01_vd03)),
         hhinc_renters_10_nad = as.numeric(as.character(hd01_vd04)),
         #Adjust for inflation 2015 dollars
         hhinc_all_10 = hhinc_all_10_nad/0.92, 
         hhinc_owners_10 = hhinc_owners_10_nad/0.92, 
         hhinc_renters_10 = hhinc_renters_10_nad/0.92) %>% 
  select(CT_id_full, hhinc_all_10, hhinc_owners_10, hhinc_renters_10)

hhinc_00<- glue("{data_dir}/02_median_hh_inc_tenure/{y_00}HCT012{suffix}") %>% 
  read.csv(na="0") %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         hhinc_all_00_nad = as.numeric(as.character(vd02)),
         hhinc_owners_00_nad = as.numeric(as.character(vd03)),
         hhinc_renters_00_nad = as.numeric(as.character(vd04)),
         #Adjust for inflation 2015 dollars
         hhinc_all_00 = hhinc_all_00_nad/0.73, 
         hhinc_owners_00 = hhinc_owners_00_nad/0.73, 
         hhinc_renters_00 = hhinc_renters_00_nad/0.73) %>% 
  select(CT_id_full, hhinc_all_00, hhinc_owners_00, hhinc_renters_00)

#Gross rent as pct of income (household)
#B25071
#H070
sh_inc_rent_15<- glue("{data_dir}/03_median_gross_rent_pct_hhinc/{y_15}B25071{suffix}") %>% 
  read.csv(na="-") %>% as_tibble() %>% rename_all(tolower)%>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         pct_inc_rent_15=as.numeric(as.character(hd01_vd01))
  ) %>% select(CT_id_full, pct_inc_rent_15)

sh_inc_rent_10<- glue("{data_dir}/03_median_gross_rent_pct_hhinc/{y_10}B25071{suffix}") %>% 
  read.csv(na="-") %>% as_tibble() %>% rename_all(tolower)%>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         pct_inc_rent_10=as.numeric(as.character(hd01_vd01))
  ) %>% select(CT_id_full, pct_inc_rent_10)

sh_inc_rent_00<- glue("{data_dir}/03_median_gross_rent_pct_hhinc/{y_00}H070{suffix}") %>% 
  read.csv(na="0") %>% as_tibble() %>% rename_all(tolower)%>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         pct_inc_rent_00=as.numeric(as.character(vd01))
  ) %>% select(CT_id_full, pct_inc_rent_00)

#Year moved (household)
#B25038
#H038
y_moved_15<- glue("{data_dir}/04_hhs_tenure_year_moved/{y_15}B25038{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         total_hh_15=as.numeric(as.character(hd01_vd01)),
         owner_hh_15=as.numeric(as.character(hd01_vd02)),
         renter_hh_15=as.numeric(as.character(hd01_vd09)),
         own_rate_15=owner_hh_15/total_hh_15,
         #Moved in the last year
         owner_1ymoved_15=as.numeric(as.character(hd01_vd03)),
         renter_1ymoved_15=as.numeric(as.character(hd01_vd10)), 
         tot_1ymoved_15= (owner_1ymoved_15+renter_1ymoved_15),
         sh_1ymoved_15= (tot_1ymoved_15/total_hh_15),
         #Moved in the last 5years (including in the last year)
         owner_5ymoved_15=(as.numeric(as.character(hd01_vd03))+as.numeric(as.character(hd01_vd04))),
         renter_5ymoved_15=(as.numeric(as.character(hd01_vd10))+as.numeric(as.character(hd01_vd11))), 
         tot_5ymoved_15= (owner_5ymoved_15+renter_5ymoved_15),
         sh_5ymoved_15= (tot_1ymoved_15/total_hh_15)
  ) %>% 
  select(CT_id_full, total_hh_15, owner_hh_15, renter_hh_15, own_rate_15, owner_1ymoved_15, renter_1ymoved_15,
         tot_1ymoved_15, sh_1ymoved_15, owner_5ymoved_15, renter_5ymoved_15, tot_5ymoved_15, sh_5ymoved_15)

y_moved_10<- glue("{data_dir}/04_hhs_tenure_year_moved/{y_10}B25038{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         total_hh_10=as.numeric(as.character(hd01_vd01)),
         owner_hh_10=as.numeric(as.character(hd01_vd02)),
         renter_hh_10=as.numeric(as.character(hd01_vd09)),
         own_rate_10=owner_hh_10/total_hh_10,
         #Moved in the last year
         owner_1ymoved_10=as.numeric(as.character(hd01_vd03)),
         renter_1ymoved_10=as.numeric(as.character(hd01_vd10)), 
         tot_1ymoved_10= (owner_1ymoved_10+renter_1ymoved_10),
         sh_1ymoved_10= (tot_1ymoved_10/total_hh_10),
         #Moved in the last 5years (including in the last year)
         owner_5ymoved_10=(as.numeric(as.character(hd01_vd03))+as.numeric(as.character(hd01_vd04))),
         renter_5ymoved_10=(as.numeric(as.character(hd01_vd10))+as.numeric(as.character(hd01_vd11))), 
         tot_5ymoved_10= (owner_5ymoved_10+renter_5ymoved_10),
         sh_5ymoved_10= (tot_1ymoved_10/total_hh_10)
  ) %>% 
  select(CT_id_full, total_hh_10, owner_hh_10, renter_hh_10, own_rate_10, owner_1ymoved_10, renter_1ymoved_10,
         tot_1ymoved_10, sh_1ymoved_10, owner_5ymoved_10, renter_5ymoved_10, tot_5ymoved_10, sh_5ymoved_10)

y_moved_00<- glue("{data_dir}/04_hhs_tenure_year_moved/{y_00}H038{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         total_hh_00=as.numeric(as.character(vd01)),
         owner_hh_00=as.numeric(as.character(vd02)),
         renter_hh_00=as.numeric(as.character(vd09)),
         own_rate_00=owner_hh_00/total_hh_00,
         #Moved in the last year
         owner_1ymoved_00=as.numeric(as.character(vd03)),
         renter_1ymoved_00=as.numeric(as.character(vd10)), 
         tot_1ymoved_00= (owner_1ymoved_00+renter_1ymoved_00),
         sh_1ymoved_00= (tot_1ymoved_00/total_hh_00),
         #Moved in the last 5years (including in the last year)
         owner_5ymoved_00=(as.numeric(as.character(vd03))+as.numeric(as.character(vd04))),
         renter_5ymoved_00=(as.numeric(as.character(vd10))+as.numeric(as.character(vd11))), 
         tot_5ymoved_00= (owner_5ymoved_00+renter_5ymoved_00),
         sh_5ymoved_00= (tot_1ymoved_00/total_hh_00)
         ) %>% 
  select(CT_id_full, total_hh_00, owner_hh_00, renter_hh_00, own_rate_00, owner_1ymoved_00, renter_1ymoved_00,
         tot_1ymoved_00, sh_1ymoved_00, owner_5ymoved_00, renter_5ymoved_00, tot_5ymoved_00, sh_5ymoved_00)

#Race (householder)
#B25006
#H009
hhrace_15<- glue("{data_dir}/05_race/{y_15}B25006{suffix}") %>% 
  read.csv(na="0") %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         total_hh_15=as.numeric(as.character(hd01_vd01)),
         nwhite_hh_15=as.numeric(as.character(hd01_vd02)),
         nblack_hh_15=as.numeric(as.character(hd01_vd03)),
         nasian_hh_15=as.numeric(as.character(hd01_vd05)),
         nother_hh_15=(as.numeric(as.character(hd01_vd04))+as.numeric(as.character(hd01_vd06))+as.numeric(as.character(hd01_vd07))+as.numeric(as.character(hd01_vd08))+as.numeric(as.character(hd01_vd09))+as.numeric(as.character(hd01_vd09))),
         #Share of households by race
         shwhite_hh_15 = (nwhite_hh_15/total_hh_15),
         shblack_hh_15 = (nblack_hh_15/total_hh_15),
         shasian_hh_15 = (nasian_hh_15/total_hh_15),
         shother_hh_15 = (nother_hh_15/total_hh_15)
  ) %>% 
  select(CT_id_full, shwhite_hh_15, shblack_hh_15, shasian_hh_15, shother_hh_15)  
         
hhrace_10<- glue("{data_dir}/05_race/{y_10}B25006{suffix}") %>% 
  read.csv(na="0") %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         total_hh_10=as.numeric(as.character(hd01_vd01)),
         nwhite_hh_10=as.numeric(as.character(hd01_vd02)),
         nblack_hh_10=as.numeric(as.character(hd01_vd03)),
         nasian_hh_10=as.numeric(as.character(hd01_vd05)),
         nother_hh_10=(as.numeric(as.character(hd01_vd04))+as.numeric(as.character(hd01_vd06))+as.numeric(as.character(hd01_vd07))+as.numeric(as.character(hd01_vd08))+as.numeric(as.character(hd01_vd09))+as.numeric(as.character(hd01_vd09))),
         #Share of households by race
         shwhite_hh_10 = (nwhite_hh_10/total_hh_10),
         shblack_hh_10 = (nblack_hh_10/total_hh_10),
         shasian_hh_10 = (nasian_hh_10/total_hh_10),
         shother_hh_10 = (nother_hh_10/total_hh_10)
  ) %>% 
  select(CT_id_full, shwhite_hh_10, shblack_hh_10, shasian_hh_10, shother_hh_10)               

hhrace_00<- glue("{data_dir}/05_race/{y_00}H009{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower)  %>% filter(geo.id2 != "Id2") %>% 
  mutate(CT_id_full=geo.id2,
         total_hh_00=as.numeric(as.character(vd01)),
         nwhite_hh_00=as.numeric(as.character(vd02)),
         nblack_hh_00=as.numeric(as.character(vd03)),
         nasian_hh_00=as.numeric(as.character(vd05)),
         nother_hh_00=(as.numeric(as.character(vd04))+as.numeric(as.character(vd06))+as.numeric(as.character(vd07))+as.numeric(as.character(vd08))),
         #Share of households by race
         shwhite_hh_00 = (nwhite_hh_00/total_hh_00),
         shblack_hh_00 = (nblack_hh_00/total_hh_00),
         shasian_hh_00 = (nasian_hh_00/total_hh_00),
         shother_hh_00 = (nother_hh_00/total_hh_00)
  ) %>% 
  select(CT_id_full, shwhite_hh_00, shblack_hh_00, shasian_hh_00, shother_hh_00)

#Educational Attainment (population 25+)
#B15002
#P037
educ_15<- glue("{data_dir}/06_educ_attainment/{y_15}B15002{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower)%>% filter(geo.id2 != "Id2") %>% 
  mutate(
    CT_id_full=geo.id2,
    #Total population 25+ (male and female)
    tot_p25= as.numeric(as.character(hd01_vd01)),
    #No schooling
    educ1_ns_15= (as.numeric(as.character(hd01_vd03))+as.numeric(as.character(hd01_vd20))),
    #Highschool or less (male:hd01_vd03-hd01_vd011), (female:vd21-vd28)
    educ2_hs_15=(as.numeric(as.character(hd01_vd04))+as.numeric(as.character(hd01_vd11))+
                   as.numeric(as.character(hd01_vd05))+as.numeric(as.character(hd01_vd06))+
                   as.numeric(as.character(hd01_vd07))+as.numeric(as.character(hd01_vd08))+
                   as.numeric(as.character(hd01_vd09))+as.numeric(as.character(hd01_vd10))+
                   #Female
                   as.numeric(as.character(hd01_vd21))+as.numeric(as.character(hd01_vd22))+
                   as.numeric(as.character(hd01_vd23))+as.numeric(as.character(hd01_vd24))+
                   as.numeric(as.character(hd01_vd25))+as.numeric(as.character(hd01_vd26))+
                   as.numeric(as.character(hd01_vd27))+as.numeric(as.character(hd01_vd28))
    ),
    #Some college (male:hd01_vd12-hd01_vd14) (female: 29-31)
    educ3_sc_15=(as.numeric(as.character(hd01_vd12))+as.numeric(as.character(hd01_vd13))+
                   as.numeric(as.character(hd01_vd14))+as.numeric(as.character(hd01_vd29))+
                   as.numeric(as.character(hd01_vd30))+as.numeric(as.character(hd01_vd31))
    ),
    #Bachelor degree or more (male:hd01_vd15-hd01_vd18) (female: 32 - 35 )
    educ4_bc_15=(as.numeric(as.character(hd01_vd15))+as.numeric(as.character(hd01_vd16))+
                   as.numeric(as.character(hd01_vd17))+as.numeric(as.character(hd01_vd18))+
                   as.numeric(as.character(hd01_vd32))+as.numeric(as.character(hd01_vd33))+
                   as.numeric(as.character(hd01_vd34))+as.numeric(as.character(hd01_vd35))
    ),
    #Share of population 25+ per each educational level
    ed1_ns_15 = (educ1_ns_15/tot_p25),
    ed2_hs_15 = (educ2_hs_15/tot_p25),
    ed3_sc_15 = (educ3_sc_15/tot_p25),
    ed4_bc_15 = (educ4_bc_15/tot_p25)
  ) %>% 
  select(CT_id_full, ed1_ns_15, ed2_hs_15, ed3_sc_15, ed4_bc_15)


educ_10<- glue("{data_dir}/06_educ_attainment/{y_10}B15002{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(
    CT_id_full=geo.id2,
    #Total population 25+ (male and female)
    tot_p25= as.numeric(as.character(hd01_vd01)),
    #No schooling
    educ1_ns_10= (as.numeric(as.character(hd01_vd03))+as.numeric(as.character(hd01_vd20))),
    #Highschool or less (male:hd01_vd03-hd01_vd011), (female:vd21-vd28)
    educ2_hs_10=(as.numeric(as.character(hd01_vd04))+as.numeric(as.character(hd01_vd11))+
                   as.numeric(as.character(hd01_vd05))+as.numeric(as.character(hd01_vd06))+
                   as.numeric(as.character(hd01_vd07))+as.numeric(as.character(hd01_vd08))+
                   as.numeric(as.character(hd01_vd09))+as.numeric(as.character(hd01_vd10))+
                   #Female
                   as.numeric(as.character(hd01_vd21))+as.numeric(as.character(hd01_vd22))+
                   as.numeric(as.character(hd01_vd23))+as.numeric(as.character(hd01_vd24))+
                   as.numeric(as.character(hd01_vd25))+as.numeric(as.character(hd01_vd26))+
                   as.numeric(as.character(hd01_vd27))+as.numeric(as.character(hd01_vd28))
    ),
    #Some college (male:hd01_vd12-hd01_vd14) (female: 29-31)
    educ3_sc_10=(as.numeric(as.character(hd01_vd12))+as.numeric(as.character(hd01_vd13))+
                   as.numeric(as.character(hd01_vd14))+as.numeric(as.character(hd01_vd29))+
                   as.numeric(as.character(hd01_vd30))+as.numeric(as.character(hd01_vd31))
    ),
    #Bachelor degree or more (male:hd01_vd15-hd01_vd18) (female: 32 - 35 )
    educ4_bc_10=(as.numeric(as.character(hd01_vd15))+as.numeric(as.character(hd01_vd16))+
                   as.numeric(as.character(hd01_vd17))+as.numeric(as.character(hd01_vd18))+
                   as.numeric(as.character(hd01_vd32))+as.numeric(as.character(hd01_vd33))+
                   as.numeric(as.character(hd01_vd34))+as.numeric(as.character(hd01_vd35))
    ),
    #Share of population 25+ per each educational level
    ed1_ns_10 = (educ1_ns_10/tot_p25),
    ed2_hs_10 = (educ2_hs_10/tot_p25),
    ed3_sc_10 = (educ3_sc_10/tot_p25),
    ed4_bc_10 = (educ4_bc_10/tot_p25)
  ) %>% 
  select(CT_id_full, ed1_ns_10, ed2_hs_10, ed3_sc_10, ed4_bc_10)


educ_00<- glue("{data_dir}/06_educ_attainment/{y_00}P037{suffix}") %>% 
  read.csv() %>% as_tibble() %>% rename_all(tolower) %>% filter(geo.id2 != "Id2") %>% 
  mutate(
    CT_id_full=geo.id2,
    #Total population 25+ (male and female)
    tot_p25= as.numeric(as.character(vd01)),
    #No schooling
    educ1_ns_00= (as.numeric(as.character(vd03))+as.numeric(as.character(vd20))),
    #Highschool or less (male:vd03-vd011), (female:vd21-vd28)
    educ2_hs_00=(as.numeric(as.character(vd04))+as.numeric(as.character(vd11))+
                   as.numeric(as.character(vd05))+as.numeric(as.character(vd06))+
                   as.numeric(as.character(vd07))+as.numeric(as.character(vd08))+
                   as.numeric(as.character(vd09))+as.numeric(as.character(vd10))+
                   #Female
                   as.numeric(as.character(vd21))+as.numeric(as.character(vd22))+
                   as.numeric(as.character(vd23))+as.numeric(as.character(vd24))+
                   as.numeric(as.character(vd25))+as.numeric(as.character(vd26))+
                   as.numeric(as.character(vd27))+as.numeric(as.character(vd28))
                 ),
    #Some college (male:vd12-vd14) (female: 29-31)
    educ3_sc_00=(as.numeric(as.character(vd12))+as.numeric(as.character(vd13))+
                   as.numeric(as.character(vd14))+as.numeric(as.character(vd29))+
                   as.numeric(as.character(vd30))+as.numeric(as.character(vd31))
    ),
    #Bachelor degree or more (male:vd15-vd18) (female: 32 - 35 )
    educ4_bc_00=(as.numeric(as.character(vd15))+as.numeric(as.character(vd16))+
                   as.numeric(as.character(vd17))+as.numeric(as.character(vd18))+
                   as.numeric(as.character(vd32))+as.numeric(as.character(vd33))+
                   as.numeric(as.character(vd34))+as.numeric(as.character(vd35))
    ),
    #Share of population 25+ per each educational level
    ed1_ns_00 = (educ1_ns_00/tot_p25),
    ed2_hs_00 = (educ2_hs_00/tot_p25),
    ed3_sc_00 = (educ3_sc_00/tot_p25),
    ed4_bc_00 = (educ4_bc_00/tot_p25)
    ) %>% 
  select(CT_id_full, ed1_ns_00, ed2_hs_00, ed3_sc_00, ed4_bc_00)

#rent data to do left join, excluding the left term (rent_00)
rent <- rent_00 %>% left_join(rent_10, by="CT_id_full") %>%  left_join(rent_15, by="CT_id_full")
#join of income data
income <- hhinc_00 %>% left_join(hhinc_10, by="CT_id_full") %>% left_join(hhinc_15, by="CT_id_full")
#join of share of income spent on rent data
sh_inc_rent<- sh_inc_rent_00 %>% left_join(sh_inc_rent_10, by="CT_id_full") %>% left_join(sh_inc_rent_15, by="CT_id_full") 
#join of share of income spent on rent data
year_moved<- y_moved_00 %>% left_join(y_moved_10, by="CT_id_full") %>% left_join(y_moved_15, by="CT_id_full")
#join race data
race <- hhrace_00 %>% left_join(hhrace_10, by="CT_id_full") %>%  left_join(hhrace_15, by="CT_id_full")
#join education
educ <- educ_00 %>% left_join(educ_10, by="CT_id_full") %>%  left_join(educ_15, by="CT_id_full")

#Join all data
clean_hh <- rent %>% left_join(income, by="CT_id_full") %>% left_join(sh_inc_rent, by="CT_id_full") %>% 
  left_join(year_moved, by="CT_id_full") %>% left_join(race, by="CT_id_full") %>% 
  left_join(educ, by="CT_id_full")

#Export full data
exp_path<- "/Users/MoniFlores/Desktop/NYU 4th semester/Data Analysis for Public Policy/HH/Clean"

clean_hh %>% write.csv2(glue("{exp_path}/CT_HHinfo_Full.csv"), na="")

clean_hh %>% write.csv(glue("{exp_path}/CT_HHinfo_Full_2.csv"), na="")

clean_hh %>% write.dta(glue("{exp_path}/CT_HHinfo_Full.dta"))
