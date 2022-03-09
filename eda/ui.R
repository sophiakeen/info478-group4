#ui.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
#library(rsconnect)


# Define UI

introduction_view <- tabPanel("Home",
                              titlePanel("Introduction"),
                              mainPanel(h3("Purpose"),
                              p(" Mental health is a large global issue that impacts people of all demographics.
                                With this research project, we're aiming to better understand the correlation between mental health, healthcare, and socioeconomic status.")
                              ), 
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

#INCOME PAGE
income_years <- unique(ad_income$Year)
income_view <- tabPanel("Income",
                                 titlePanel("Income vs. Depression"),
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(
                              inputId = "year_input",
                              label = "Select Year",
                              choices = income_years,
                              selected = "2018"
                            )),
                       
                          mainPanel(
                          h3("How does socioeconomic status level impact prevalence of depression?"),
                          p("One of our objectives for this project is to better understand 
                            the correlation between mental health and socioeconomic status.
                            This bar chart is a example of what we can analyze and examine from the Adult Depression (LGHC Indicator) dataset found here:"),
                          uiOutput("tab"),
                            p("In this dataset, the California Behavioral Risk Factor Surveillance Survey (BRFSS) asked California residents the question:
                              “Has a doctor, nurse or other health professional EVER told you that you have a depressive disorder (including depression, major depression,dysthymia, or minor depression)?” 
                            This plot compares resident income and the Weighted Frequency, which refers to Frequency with a population weight applied (the estimated count in the population with the combination of values).
                            This plot shows each year from 2012 to 2018."),
                         
                          plotlyOutput("incomechart"),
                          
                          
                          )
                        
))

summary_view <- tabPanel("Conclusion",
                              titlePanel("Conclusion"),
                              mainPanel( 
                                h3("Income vs. Depression Analysis"),
                                p("Below are two Income vs. Weighted Depression Frequency bar charts.
                                  The first one is 2012 data and the second one is 2018 data."),
                                p(""),
                                h4("2012"),
                                plotlyOutput("income2012chart"),
                                h4("2018"),
                                plotlyOutput("income2018chart"),
                                p("")
                                
                                
                                ), 
)

# user interface variable that holds all of the pages presented in shiny
ui <- fluidPage(
  #includeCSS("finalprojectstyle.css"),
  navbarPage(
    #inverse = TRUE,
  #tags$div(
      #img(
       # src = "https://media.giphy.com/media/5BUR9eNQdG5egwA0pO/giphy.gif",
       # width = "216px", height = "48px"
      #),
      "Exploring Mental Health Correlations"
    #)
  ,
    introduction_view,
    facilities_view,
    income_view,
#    decades_page,
    summary_view,
    #setBackgroundColor("#212121") error says can't find setBackgroundColor
  )
)