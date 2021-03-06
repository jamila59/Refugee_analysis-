# Usually have this in a different file, worry about that wednesday
# Load data and shapefile
library(tidyverse)
library("shiny")
all_data <- read.csv("data/population.csv", skip = 14)
shapefile <- map_data("world")


# List of iso3 codes
country_df <- all_data %>% 
  distinct(Country.of.asylum..ISO., Country.of.asylum)

choices <- setNames(country_df$Country.of.asylum..ISO.,country_df$Country.of.asylum)
ui <- fluidPage(
  h1("Asylum Application"), 
  selectInput(
    inputId = "iso3", 
    label = "Choose a country", 
    choices = choices
  ),
  plotOutput(outputId = "map")
)

# This defines a server that doesn't do anything yet, but is needed to run the app.
server <- function(input, output) {
  # Will be next!
  output$map <- renderPlot({
    iso3 <- input$iso3
    country_name <- countrycode(iso3, origin = 'iso3c', destination = 'country.name')
    
    country_data <- all_data %>% 
      filter(Country.of.asylum..ISO. == iso3)
    
    country_shapefile <- shapefile %>% 
      mutate(Country.of.origin..ISO. = countrycode(region, origin = 'country.name', destination = 'iso3c')) %>% 
      left_join(country_data, by = "Country.of.origin..ISO.")
    
    asylum_map <- ggplot(data = country_shapefile) +
      geom_polygon(
        mapping = aes(x = long, y = lat, group = group, fill = Asylum.seekers)
      ) +
      labs(title = paste("Number of People Seeking Asylum in", country_name), 
           x = "", y = "", fill = "Num. People") +
      theme_minimal()
    
    return(asylum_map)
  })
}

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)