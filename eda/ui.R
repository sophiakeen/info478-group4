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
                              h3("Overview of Assignment"), 
)


deterministic_view <- tabPanel("Deterministic Model",
                               titlePanel(""),
                               h3(""),
)


stochastic_page_view <- tabPanel("Stochastic Model",
                                 titlePanel(""),
)