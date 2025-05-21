
########################################################
### 1. Data Cleaning and Exploring
########################################################

library(tidyverse)  # To wrangle data
library(janitor)    # Additional data cleaning tools
library(here)       # To work with relative file paths

# File > New Project > Select Directory
whr15 <- read.csv(here("Data_DIME_R", "DataWork", "DataSets", "Raw", "Un WHR", "WHR2015.csv"))
whr16 <- read.csv(here("Data_DIME_R", "DataWork", "DataSets", "Raw", "Un WHR", "WHR2016.csv"))
whr17 <- read.csv(here("Data_DIME_R", "DataWork", "DataSets", "Raw", "Un WHR", "WHR2017.csv"))

# 1.1 Clean variable names (Janitor package)
View(whr15)
whr15 <- whr15 %>% clean_names()
whr16 <- whr16 %>% clean_names()
whr17 <- whr17 %>% clean_names()

# 1.2 Exploring a dataset
glimpse(whr15)   # Compact overview of dataset from tidyverse
class(whr15) # Object type (data frame, list, etc.)
dim(whr16) # Dimention of dataset (Number of rows & columns)
names(whr16) # Variable names
str(whr17) # Structure of dataset
summary(whr15) # Summary stat
head(data)      # First few observations
tail(data)      # Last few observations

n_distinct(whr15$country, na.rm = TRUE) # Number of distinct values, don't count missing value
n_distinct(whr15$region, na.rm = TRUE)



########################################################
### 2. Data Wrangling
########################################################

# 2.1 Filtering
library(dplyr)  
whr15 %>% filter(region == "Western Europe")
whr15 %>% 
  filter(region %in% c("Eastern Asia", "North America"))

# 2.2 Sorting missing cases
whr15 %>% 
  filter(!is.na(region)) %>% head(5)

# 2.3 Add new column or transform existing ones using "mutate"
whr15_2 <- whr15 %>%
  mutate(hap_hle = happiness_score * health_life_expectancy)
View(whr15_2)

# The new column returns T/F
whr15_3 <- whr15 %>%
  mutate(happiness_score_6 = (happiness_score > 6)) 
View(whr15_3)

# The new column  returns 1 = T, 0 = F
whr15_4 <- whr15 %>% mutate(
    happiness_high_mean = as.numeric((happiness_score > mean(happiness_score, na.rm = TRUE)))
  )
View(whr15_4)

# Create year variable of each dataframe
whr15 <- whr15 %>% mutate(year = 2015)
whr16 <- whr16 %>% mutate(year = 2016)
whr17 <- whr17 %>% mutate(year = 2017)
View(whr17)

# 2.4 Create variables using group_by()
# Create mean happiness of each region
whr15 %>% 
  group_by(region) %>% 
  mutate(mean_hap = mean(happiness_score, na.rm = TRUE)) %>%
  select(country, region, happiness_score, mean_hap)

# 2.5 Create multiple variables using across() inside summarize/mutate
# create 3 new variables: the mean value for happiness_score, health_life_expectancy, and trust_government_corruption, for each region

vars <- c("happiness_score", "health_life_expectancy", "trust_government_corruption")
whr15_5 <- whr15 %>%
  group_by(region) %>%
  summarize(across(all_of(vars), mean))
View(whr15_5)

