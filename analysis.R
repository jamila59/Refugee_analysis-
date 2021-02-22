# Analysis of UNHCR data


# Set up ------------------------------------------------------------------

# Simple exploration
dim(all_data)
unique(all_data$Year)
length(unique(all_data$Country.of.origin))
length(unique(all_data$Country.of.asylum))

data <- all_data %>% 
  filter(Year == 2020) %>% 
  select(contains("Country"), Asylum.seekers)
dim(data)

country_of_interest <- "ESP"
country_name <- countrycode(country_of_interest, origin = 'iso3c', destination = 'country.name')
  
country_data <- data %>% 
  filter(Country.of.asylum..ISO. == country_of_interest)





# Make a map --------------------------------------------------------------



# Get iso3 codes and join on our data
