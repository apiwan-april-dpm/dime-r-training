
########################################################
### 1. Introduction to R
### Introduction to R syntax, objects and classes
########################################################

## 1.1 Object classes: Variables
# Everything that exists in R's memory (variables, dataframes, functions) is an object

v1 <- c(1,2,3,4,5) # Creating a vector with the c() function
v2 <- 1:5 # Alternative way to create an evenly spaced vector

v2[4]   # Prints the 4th element of the vector
v2[1:4] # Prints from the 1st to the 4th element

## 1.2 Object classes: Dataframes
df1 <- data.frame(v1,v2) # Create dataframe by combining vectors

whr[,1]   # The 1st column of whr
whr[45,]  # The 45th row of whr
whr[45,"country"] # The 45th row of the 1st column

## 1.3 Object classes: Lists
lst <- list(v2, df1, 45) # lists contain many objects of different classes and dimensions
print(lst)



########################################################
### 2. Introduction to R Programming
### Code organization, libraries, loops, custom functions and programming practices
########################################################

# 2.1 Set work directory
getwd() # Print current work directory
rm(list = ls()) # The equivalent of clear in R
setwd("/Users/puengapiwan/Desktop/Georgetown University/2. Spring'25/DataViz/Data") 

# 2.2 Set project directory
# Ensures that your file paths always start from the root of project directory, not from current working directory
install.packages("here") 
library(here)
whr <- read.csv(here("DataWork", "DataSets", "Final", "whr_panel.csv"))

# 2.3 Install packages
# Install a package once, but load them every new session with library()
install.packages("dplyr") # data manipulation i.e. filter, join data sets, pipes
install.packages("tidyverse") # collection of data science packages i.e. ggplot2, dplyr, tidyr, forcats
install.packages("janitor") # data cleaning
install.packages("readxl")
install.packages("forcats") # work with categorical data i.e. reorder factor levels
install.packages("purrr")

library(dplyr) 
library(tidyverse)
library(janitor)
library(readxl)
library(forcats)
library(purrr)

# 2.4 Meta Programming, writing function inside function
summary(log(whr$happiness_score))

# 2.5 Piping (%>%), improving code readability
# x %>% f() is the same as f(x), from "dplyr" package
whr$happiness_score %>% log() %>% mean()

# 2.6 Iteration
# Looping repeat the same operation over the values, while mapping applies the operation at once
for (number in 1:4) {
  print(number)
}

x <- c(1.25, 2.56, 9.13, 5.88)
map(x, round) # round the values at once

# Looping over a data frame
df <- data.frame(replicate(50000, sample(1:100, 400, replace=TRUE))) # Draw 400 random numbers from integers 1-100
col_means_loop <- c() # Create a vector to store column means

for (col in df){
  col_means_loop <- append(col_means_loop, mean(col))
}
View(col_means_loop)

col_means_map <- map(df, mean)
View(col_means_map)

# 2.7 Custom functions
# Calculate z-score manually
mean_x <- mean(x)
sd_x <- sd(x)
z_scores <- c()

for (val in x) {
  z <- (val - mean_x)/sd_x
  z_scores <- append(z_scores, z)
}

# Calculate z-scores of health_life_expectancy and freedom columns
z_scores2 <- whr %>%
  select(health_life_expectancy, freedom) %>% map(zscore)
whr$hle_st <- z_scores2[[1]]
whr$freedom_st <- z_scores[[2]]
View(whr)
