# app.Rvfor INFO 478

library(shiny)
library(plotly)
library(tidyverse)
library(ggplot2)
library(dplyr)


source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)