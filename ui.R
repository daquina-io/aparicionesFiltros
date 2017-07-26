library(shiny)
library(leaflet)


## Define UI for dataset viewer application
## checkboxInput("legend", "Mostrar leyenda", TRUE),
ui <- function(request) {
  bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  titlePanel("Apariciones de grupos "),
                  sliderInput("range", "Capacidad", 0, 20000,value = c(10,3000), step = 1 ),
                  dateRangeInput("dates", start = "1970-01-01", end = "2018-01-01", label = h3("Rango de fechas")),
                  selectInput("wday", "Día de la semana", c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"), multiple=TRUE, selectize=TRUE, selected = c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")),
                  bookmarkButton()
                  )
  )
}
