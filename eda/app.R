# app.Rvfor INFO 478

library(shiny)
library(plotly)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(rsconnect)


source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)