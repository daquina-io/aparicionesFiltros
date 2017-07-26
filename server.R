if(!require(shiny)) install.packages('shiny')
if(!require(dplyr)) install.packages('dplyr')
if(!require(leaflet)) {
  devtools::install_github('rstudio/leaflet')
  devtools::install_github('bhaskarvk/leaflet.extras')
}
require(readr)
require(lubridate)
##library(RColorBrewer)

points <- read_csv("https://raw.githubusercontent.com/daquina-io/apariciones/master/data/points.csv")
points <- points[points$lat != "INVALID",]
points <- points[points$lon != "INVALID",]
points <- points[as.numeric(points$lon) < -70,]
points <- points[!is.na(points$lat),]
points$date_hour <- mdy_hms(paste0(points$date," ",points$hour))
points$date_hour <- points$date_hour

## intervalos fechas
intervalo_fechas <- function(start_end) { (interval(start_end[1],start_end[2])) }

## exclude values > 500
##points <- points[points$pm25 < 500,]

## colors
points$colors <- lapply(points$capacity, function(x)(
  ifelse(x < 100 , "green",
    ifelse(x < 500 , "orange",
      ifelse( x < 3000, "red","purple")))
))

shinyServer(function(input, output) {
  data <- reactive({
    points %>% filter( wday(date_hour, label=TRUE, abbr=FALSE) %in% input$wday, capacity >= input$range[1], capacity <= input$range[2], date_hour%within% intervalo_fechas(input$dates))  -> filtered_points
    filtered_points
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
       fitBounds(-75.5, 6.2, -75.57, 6.28)
  })

  observe({
    leafletProxy("map", data = data()) %>%
      clearShapes() %>%
      ## addCircles(~as.numeric(lng), ~as.numeric(lat), popup = ~as.character(pm25), fillOpacity = 0.7, radius = ~as.numeric(pm25)) ## no colors
      addCircles(~as.numeric(lon), ~as.numeric(lat), popup = ~paste(name,capacity,venue,date), fillOpacity = 0.7, radius = 10, color = ~colors)
  })
})
