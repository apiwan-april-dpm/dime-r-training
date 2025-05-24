
########################################################
### 1. Quick Summary Statistics
########################################################

install.packages("modelsummary") # to export easy descriptive tables
install.packages("fixest")       # easy fixed effects regressions
install.packages("huxtable")     # easy regression tables
install.packages("openxlsx")     # export tables to Excel format
install.packages("estimatr")     # backend calculations for balance tables

library(here)
library(tidyverse)
library(modelsummary)
library(fixest)
library(janitor)
library(huxtable)
library(openxlsx)

census <- read_rds(here(
      "DataWork", "DataSets", "Final", "census.rds"))

glimpse(census)
summary(census) # summarize continuous variables
census %>% tabyl(state, region) # summarize categorical variables



########################################################
### 2. Descriptive Tables
########################################################

# 2.1 Create descriptive statistics tables (mean, sd, min, med, max)
datasummary_skim(census) 
datasummary_skim(census %>% select(region), type = "categorical")

# 2.2 Create customized descriptive statistics tables
datasummary( 
  pop + death + marriage + divorce ~ N + Mean + SD + P0 + P25 + P50 + P75 + P100,
  data = census)

datasummary(All(census) ~ N + Mean + SD + Median + Min + Max,
  data = census)

# 2.3 Create balance tables
# Creating treatment variable 
census_rct <- census %>% mutate(
  treatment = as.numeric(runif(n()) > 0.5)) %>% # Return T/F randomly
  select(-c(state, state2, region)) # Drop columns from the data set

# Create balance table
datasummary_balance(~ treatment,
  data = census_rct)

# datasummary_correlation, to create a correlation table
# datasummary_crosstab, to create a twoway tabulation



########################################################
### 3. Exporting Tables 
########################################################

# Create the huxtable object
summary_stats_table <- datasummary(descriptives,
    data = census,
    output = "huxtable")

# Export to MS Excel/LaTex
quick_xlsx(summary_stats_table, 
  file = here("DataWork", "Output", "summary-stats-huxtable.xlsx"
  )
)

quick_latex(summary_stats_table,
  file = here("DataWork", "Output","summary-stats-huxtable.tex"
  )
)



########################################################
### 4. Regression
########################################################

# y ~ x1 + x2 regresses variable y on x1 and x2
# y ~ x1:x2 regresses variable y on the interaction of x1 and x2
# y ~ x1*x2 is equivalent to y ~ x1 + x2 + x1:x2

reg1 <- lm(divorce ~ pop + popurban + marriage, data = census)
summary(reg1)

# "feols" command from package fixest allows for more flexibility in model specification
# y ~ x1 + x2 | fe1 + fe2 | x3 ~ iv3
# fe1 + fe2 list the variables to be included as 
# x3 ~ iv3 uses instrument iv3 for variable x3

reg2 <- feols(
    divorce ~ pop + popurban + marriage | region, # Region as fixed effect
    data = census,
    vcov = cluster ~ state # Define clustered std errors by state
  )
summary(reg2)

# Formatting regression tables
reg_table <- huxreg('Model 1' = reg1, 'Model 2' = reg2,
       error_format = "[{p.value}]", # to display p-values in brackets
       coefs = c(
         "Population" = "pop", # Show variable labels instead of names
         "Urban population"  = "popurban",
         "Number of marriages" = "marriage"),
  statistics = c("N. obs." = "nobs"),
  stars = c(`***` = 0.01, `**` = 0.05, `*` = 0.1),
  note = "{stars}\nStandard errors are displayed in parentheses.") %>%
  add_rows(c("Region FE", "No", "Yes"), after = 7)

# Export to MS Excel/LaTex
quick_xlsx(reg_table,  file = here("DataWork", "Output", "regression_table.xlsx"))
quick_latex(reg_table, file = here("DataWork", "Output", "regression_table.tex"))


