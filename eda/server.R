#server.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)

source("app.R")

#Define server logic
server <- function(input, output) {
  
}

# Run the app
shinyApp(ui = ui, server = server)