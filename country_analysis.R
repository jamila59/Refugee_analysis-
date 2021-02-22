# Country Analysis
country_analysis <- function(iso3) {
  country_name <- countrycode(iso3, origin = 'iso3c', destination = 'country.name')
  
  country_data <- data %>% 
    filter(Country.of.asylum..ISO. == iso3)
  
  # High level questions ----------------------------------------------------
  
  # From how many countries do asylum seekers come from (into county of interest)?
  num_countries <- nrow(country_data)
  
  # How many people sought asylum in the country in 2020?
  num_people <- country_data %>% 
    summarize(total_people = sum(Asylum.seekers)) %>% 
    pull()
  
  top_10_countries <- country_data %>% 
    top_n(10, wt = Asylum.seekers) %>% 
    arrange(-Asylum.seekers) %>% 
    select(Country.of.origin, Asylum.seekers)
  
  country_shapefile <- shapefile %>% 
    mutate(Country.of.origin..ISO. = countrycode(region, origin = 'country.name', destination = 'iso3c')) %>% 
    left_join(country_data, by = "Country.of.origin..ISO.")
  
  # Create the map
  asylum_map <- ggplot(data = country_shapefile) +
    geom_polygon(
      mapping = aes(x = long, y = lat, group = group, fill = Asylum.seekers)
    ) +
    labs(title = paste("Number of People Seeking Asylum in", country_name), 
         x = "", y = "", fill = "Num. People") +
    theme_minimal()
  
  filename <- paste0(iso3, ".html")
  rmarkdown::render('template.Rmd', output_file = filename)
}