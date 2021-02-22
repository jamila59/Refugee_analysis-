# Run this script to make all the reports


# Set up ------------------------------------------------------------------
library(tidyverse)
library(countrycode)
source("country_analysis.R") # define our function

# Load data and shapefile
all_data <- read.csv("data/population.csv", skip = 14)
shapefile <- map_data("world")

data <- all_data %>% 
  filter(Year == 2020) %>% 
  select(contains("Country"), Asylum.seekers)

# Get a list of iso3 codes
all_iso3s <- unique(data$Country.of.asylum..ISO.)

# Apply the function to each iso3 code 
# (create a report for each country!)
sapply(all_iso3s, country_analysis)