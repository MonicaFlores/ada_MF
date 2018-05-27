## Applied Data Analysis for Public Policy
### NYU Wagner / CUSP Spring 2018
This repo contains both personal homeworks and work for group research project on policy analysis. 

## Research Project Overview

## Predicting Gentrification

 Data Analysis for Public Policy - Team 1
 NYU Wagner and CUSP - Spring 2018
 Professors: Julia Lane and Daniela Hochfellner
 Team Members: Matthew Barry, Monica Flores, Zarni Htet, Yinlingyan Wang

**Our Research Focus**: Using neighborhood amenities, demographics and neighborhood level policies (like the implementation of Business Improvement Districts) to Predict Gentrification

**Gentrification Definition**: Increases in household income, education, and/or housing costs in previously low-income, central city neighborhoods. Some also consider increases in percentage of white households

**Business Improvement District (BID) Definition**: A geographical area where local stakeholders oversee and fund the maintenance, improvement, and promotion of their commercial district.

### The Notebooks

* **01_Block_Data_Clean.ipynb** In this notebook, we cleaned the data obtained from the Center for Urban Research, The Graduate Center, City University of New York (CUNY) 
* **02_BID_Block_match.ipynb** In this notebook, we joined the Business Improvement District (BID) information to the Block Level data using BIDs unique identifier number as a key. 
* **03_CT_Data_Clean.ipynb** In this notebook, we cleaned the DOB_Certificate of Occupancy data and merge with our existing block data.
* **04_BID_CT_matched_final.ipynb** In this notebook,  we cleaned workers' demographic data obtained from OnTheMap (U.S.Census Bureau, Center for Economic Studies)
* **05_Visualization** In this notebook, we run through several exploratory data analysis of our various datasets to the outcome variable of gentrification that we have specified to be change in percentage of white households.
* **06_LogisticRegression_Blocks.ipynb** In this notebook,  several logistic models are run on the percentage change in white household ratios of a census block as an outcome variable with an increasing set of features. A summary of results and next steps are at the end of this notebook.

### Packages You'll Need 
* numpy
* array
* pandas
* matplotlib
* matplotlib.pyplot
* matplotlib.cm
* mplot3d from mpl_toolkits
* seaborn
* sqlalchemy
* division, print_function
* warnings
* datetime
* os
* six
* re
* scipy
* sklearn
* csv
* gzip
* geopandas
* sklearn.linear_model import LogisticRegression, SGDClassifier
* sklearn.model_selection import train_test_split
* sklearn.metrics import precision_recall_curve, roc_curve, auc
* sklearn.metrics accuracy_score, precision_score, recall_score

### The Input Data

The files belows are the input data files. The data dictionary for these files are in the **Appendix** section down below.

* **BBL_BLOCKS.csv.gz**
* **block_dummies.csv**
* **block_dummies_BIDS.csv**
* **blocks_clean.csv**
* **CT_clean.csv**
* **CT_HHinfo_Full_2.csv**
* **dist_subway_parks_.csv**
* **DOB_Certificate_Of_Occupancy.csv (API call)**
* **ny_rac_S000_JT00_2002.csv.gz**
* **ny_rac_S000_JT05_2010.csv.gz**

### The Clean Data

We clean and reorganized the data to obtain the following four files. We kept only the variables of interest for our analysis.

* **Blocks_Full.csv: Census Block Level Data with BID reference**  
           Census Block ID
           Populations from 2000 and 2010
           White, Latino, Black, Asian and Other Populations in 2000 and 2010
           Percentage Change in those Populations from 2000 to 2010
           Borough Names
           Neighborhood Tabulation Area Codes and Names
           Bid ID, Name, Area, and Dummy Variable
* **dist_subway_parks_.csv: Distance Between Census Block and Amenities**  
           Census Block ID
           Distance from subway entrance
           Distance from small park
           Distance from large park
           
* **DOB_new_units_Clean.csv: Proposed Dwelling Units by Census Block** 
           Census Block ID
           Number of new proposed units from 2012

* **workers_02_10_Clean.csv: Workforce Demographic Information**  
           Census Block ID
           Income in 2002 and 2010
           Number of jobs with earnings 1250USD/month or less in 2002 & 2010
           Number of jobs with earnings between 1251 and 3333 USD/month in 2002 & 2010
           Number of jobs with earnings greater than 3333 USD/month in 2002 & 2010
           Number of jobs for workers with Educational Attainment: Less than high school in 2002 & 2010
           Number of jobs for workers with Educational Attainment: High School or Equivalent in 2002 & 2010
           Number of jobs for workers with Educational Attainment: Some college or Associate Degree in 2002 & 2010
           Number of jobs for workers with Educational Attainment: At Least Bachelor's degree in 2002 & 2010
           Percentage change in income and educational attainment from 2002 to 2010
           
#### *Data Dictionary: Input Data*

#### Block and Racial Composition of the Population
* **BLOCKID :**       Unique Census Block Indentifyier
* **Pop10 :**         Total Census Block population in 2010
* **Pop00 :**         Total Census Block population in 2000
* **blckArea_ft :**   Total area of the Census Block in sqft.

* **WHITE10 :**       Total White non-hispanic population per Block in 2010
* **LATINO10 :**      Total Hispanic population per Block in 2010
* **BLACK10 :**       Total Black non-hispanic population per Block in 2010
* **ASIAN10 :**       Total Asian non-hispanic population per Block in 2010
* **OTHERS10 :**      Total Other Race non-hispanic population per Block in 2010.

* **WHITE00 :**       Total White non-hispanic population per Block in 2000
* **LATINO00 :**      Total Hispanic population per Block in 2000
* **BLACK00 :**       Total Black non-hispanic population per Block in 2000
* **ASIAN00 :**       Total Asian non-hispanic population per Block in 2000
* **OTHERS00 :**      Total Other Race non-hispanic population per Block in 2000.

* **BoroName :**      Borough 
* **NTACode :**       Neighborhood Tabulation Area Code
* **NTAName :**       Neighborhood Tabulation Area Name.

#### Business Improvement Districts Geographic Information
* **A_poly :**        Area of the Census Block that is within a BID in sqft (if the Block is not within a BID A_poly is equal to total area of the Census Block)
* **bid_id :**        Busiiness Improvement District (BID) unique identifyier (if the Block is within a BID)
* **bid_name :**      Name of the BID
* **areaBID_ft :**    Area of the BID in sqft
* **a_weight :**      Share of the Block Area that is within a BID (if the Block is not within a BID a_weight id equal to 1)
* **BID_dummy :**     Binary variable that indicates weather the Census Block is within a BID or not.

#### BIDs Data
* **org_id :**       The ID of the BIDs
* **assessment :**         The economic scale of the BIDs
* **org_name :**         BIDs names
* **org_address :**         The address of the BIDs
* **org_address2 :**        The floor information of the BIDs
* **org_city :**         The borough name of the BIDs
* **org_state :**         The state name of the BIDs
* **org_zip :**        The zip code of the BIDs
* **boro_id :**         The borough ID of the BIDs
* **org_phone    :**         The phone number of the BIDs
* **org_year :**         The year of BIDs established
* **org_blocks :**         The number of blocks covered by BIDs
* **org_businesses :**         The number of businesses in each BID

#### Workers data
* **h_geocode:**       Residence Census Block Code
* **CE01 :**         Number of jobs with earnings 1250 dollars/month or less
* **CE02 :**         Number of jobs with earnings 1251 dollars/month to 3333 dollars/month
* **CE03 :**         Number of jobs with earnings greater than 3333 dollars/month
* **CD01 :**         Number of jobs for workers with Educational Attainment: Less than high school
* **CD02 :**         Number of jobs for workers with Educational Attainment: High school or equivalent,no college
* **CD03 :**         Number of jobs for workers with Educational Attainment: Some college or Associate degree
* **CD04 :**         Number of jobs for workers with Educational Attainment: Bachelor's degree or advanced degree

#### Certificate of Occupancy
* **JOB_NUMBER:**       Number assigned by the Department of Buildings to the job application that the Certificate of Occupancy was issued for
* **JOB_TYPE :**         2-digit code to indicate the overall job type for the application.
* **C_O_ISSUE_DATE :**         Date the Certificate of Occupancy was issued.
* **BIN_NUMBER:**         Building Identification Number (BIN) assigned by Department of City Planning.
* **BOROUGH:**         The name of the NYC borough where the building is located.
* **NUMBER :**         The house number for the building address.
* **STREET :**        The street name for the building address.
* **BLOCK :**         Tax Block assigned to the location of the building by the Department of Finance.
* **LOT:**       Tax Lot assigned to the location of the building by the Department of Finance.
* **POSTCODE :**        The Zip Code for the building address.
* **PR_DWELLING_UNIT :**         This is the proposed number of dwelling units in the building after the proposed work has been completed, as reported by the applicant.
* **EX_DWELLING_UNIT:**         This is the existing number of dwelling units in the building, as reported by the applicant.
* **APPLICATION_STATUS_RAW:**        The status of the application for a Certificate of Occupancy.
* **FILING_STATUS_RAW :**         The filing status of the application for a Certificate of Occupancy.
* **ITEM_NUMBER :**       aka Issue Number. Number of Partitioned Units of Work for a Job.
* **ISSUE_TYPE :**         The type of Certificate of Occupancy that was issued. 
* **LATITUDE :**        Geographical latitude of the building.
* **LONGITUDE :**         Geographical longitude of the building.
* **COMMUNITY_BOARD:**         Community Board Number for the building’s address.
* **COUNCIL_DISTRICT:**        Council district for the building's address.
* **BIN:**        Building Identification Number (BIN) assigned by Department of City Planning.
* **BBL:**       A number that is created by concatenating a number for the borough
* **NTA :**         Neighborhood Tabulation Area
* **LOCATION:**         Latitude and Longitude. Used for mapping purpose

#### Distance Between Census Block and Amenities
* **BLOCKID**           Census Block ID
* **dist_sub_m**           Distance in meters from subway entrance
* **dist_sPark**           Distance in meters from small park
* **dist_mPark**           Distance in meters from large park

