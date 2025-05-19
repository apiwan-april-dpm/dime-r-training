
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
lst <- list(v2, df1, 45) # lists contain many objects of different classes and dimensions.
print(lst)



########################################################
### 2. Introduction to R Programming
### Code organization, libraries, loops, custom functions and programming practices
########################################################

# 2.1 Set directory
getwd() # Print current work directory
rm(list = ls()) # The equivalent of clear in R
setwd("/Users/puengapiwan/Desktop/Georgetown University/2. Spring'25/DataViz/Data") 

# Ensures that your file paths always start from the root of project directory, not from your current working directory
install.packages("here") 
library(here)
whr <- read.csv(here("DataWork", "DataSets", "Final", "whr_panel.csv"))

# 2.3 Install packages
install.packages("dplyr") # data manipulation i.e. filter, join data sets
install.packages("tidyverse") # collection of data science packages i.e. ggplot2, dplyr, tidyr, forcats
install.packages("janitor") # data cleaning
install.packages("readxl")
install.packages("forcats") # work with categorical data i.e. reorder factor levels

# Install a package once, but load them every new session with library()
library(dplyr) 
library(tidyverse)
library(janitor)
library(readxl)
library(forcats)


