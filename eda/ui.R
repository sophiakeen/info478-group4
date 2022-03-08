#ui.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)

# Define UI

introduction_view <- tabPanel("Home",
                              titlePanel("Introduction"),
                              h3("Purpose"), 
)


facilities_view <- tabPanel("Mental Facilities",
                               titlePanel(""),
                               h1("Pick the types of facilities"),
                            sidebarPanel(
                              checkboxGroupInput(inputId = "checkGroup", 
                                                 label = h3("Pick Type of Facilities"), 
                                                 choices = list("Mental Hospitals" = 1, "Health Units" = 2, "Outpatient Facilities" = 3, "Day Treatment" = 4, "Residential Facilities" = 5),
                                                 selected = 1),
                            ),
)


income_view <- tabPanel("Income",
                                 titlePanel(""),
)

summary_view <- tabPanel("Overview",
                              titlePanel("Introduction"),
                              h3("Overview of Assignment"), 
)

# user interface variable that holds all of the pages presented in shiny
ui <- fluidPage(
  includeCSS("finalprojectstyle.css"),
  navbarPage(
    inverse = TRUE,
    tags$div(
      img(
        src = "https://media.giphy.com/media/5BUR9eNQdG5egwA0pO/giphy.gif",
        width = "216px", height = "48px"
      ),
      "Exploring Suicide Rates"
    ),
    introduction_view,
    facilities_view,
    income_view,
#    decades_page,
    summary_view,
    setBackgroundColor("#212121")
  )
)