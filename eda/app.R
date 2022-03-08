# app.Rvfor INFO 478

library(shiny)
library(plotly)

source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)