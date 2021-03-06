#ui.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)
adult_depression <- read.csv('data/adult-depression-lghc-indicator-24.csv')
ad_wider <- adult_depression %>% pivot_wider(names_from = Strata,
                                             values_from = c(Strata.Name, Frequency, Weighted.Frequency,
                                                             Lower.95..CL, Upper.95..CL))

ad_income <- ad_wider %>% select('Year', 'Strata.Name_Income', 'Frequency_Income',
                                 'Weighted.Frequency_Income', 'Lower.95..CL_Income',
                                 'Upper.95..CL_Income')
ad_income <- na.omit(ad_income)

# Define UI

introduction_view <- tabPanel("Home",
                              titlePanel("Introduction"),
                              mainPanel(h3("Purpose"),
                              p(" Mental health is a large global issue that impacts people of all demographics.
                                With this research project, we're aiming to better understand the correlation between mental health, healthcare, and socioeconomic status.
                                While we try to inform UW students on the impact of mental health and how it correlates with socioeconomic status, 
                                to a certain extent, our target audience could be anyone interested in knowing more about mental health and how it might affect their lives."),
                              h3("Research Questions"),
                              p("Our main research questions of the project are the following:"),
                              tags$ul(
                                tags$li("How does access to mental health care affect suicide rates?"),
                                tags$li("What is the correlation between socioeconomic status and mental health?"),
                              ),
                              br(),
                              p("By: Christina Tran, Sophia Keen, Youjin Jung, Katherine Poch")
                              )

                             
                              
)


facilities_view <- tabPanel("Mental Facilities",
                               titlePanel(""),
                               h1("Pick the types of facilities"),
                              
                            sidebarPanel(
                              radioButtons(inputId = "radio", 
                                                 label = h3("Pick Type of Facilities"), 
                                                 choices = list("Mental Hospitals" = "mental_hospitals", "Health Units" = "health_units",
                                                                "Outpatient Facilities" = "outpatient_facilities"),
                                                 selected = "mental_hospitals")
                            ), 
                            mainPanel(
                              h3("How does the occurace of Mental Facilities impact the rates of suicides?"),
                              p("Our first objective is to examine the correlation between mental health - in occurances of suiciudes - and number of mental facilities.
                              This scatterplot shows what we can see from the Mental Health and Suicide Rates Dataset found here:"),
                              uiOutput("tab_url"),
                              br(),
                              p("In this dataset, suicide rates of age groups in different countries along with health facilities are shown. 
                                It has information about age-standardized suicide rates, crude suicide rates, amount of mental health facilities
                                and human mental aide resources per country per 100,000 population. We took the 2016 data from age-standardized suicide rates
                                and compared them to three different health facilities - mental hospitals, health units, and outpatient facilities."),
                              br(),
                              plotlyOutput("country_facilities_plotly")
                            )
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
                         
                          plotlyOutput("incomechart")
                          
                          
                          )
                        
))

summary_view <- tabPanel("Conclusion",
                              titlePanel("Conclusion"),
                              mainPanel( 
                                h3("Facilities vs. Suicide Rates"),
                                p("Below are two of the Suicidal rates vs. Facilities rates by Country in 2016 charts. 
                                  The first one is the plot on mental hospitals and the second is on outpatient facilities."),
                                br(),
                                h4("Mental Hospitals"),
                                plotlyOutput("mentalhospitals"),
                                h4("Outpatient Facilites"),
                                plotlyOutput("outpatientfacilites"),
                                br(),
                                p("When comparing the two scatterplots, the outpatient facilities plot shows more varied 
                                  results compared to the mental hospital chart. As shown in the mental hospital plot, most 
                                  countries have a very low number of mental hospitals, but despite the low low number of hospitals,
                                  there are varying numbers of suicide rates. Almost all the countries appear to have 2 or less mental
                                  hospitals per 100,000 people. The only excpetion to this is Japan that has about 8 mental hospitals 
                                  per 100,000 people.  In this case, there isn't a correlation between the number of mental hospitals and
                                  suicide rates because, even though Japan has the highest number of mental hospitals, their suicide rate
                                  is still on the upper end of the spectrum. Countries like Antigua and Barbuda only have about 1 mental 
                                  hospital per 100,000, but have the lowest suicide rate of all. The outpaitient facilities show slightly 
                                  different data however. While a large portion of the plots are still clustered on the lower end of the 
                                  spectrum (in terms of number of facilities), they are spread out a little more and there are more countries 
                                  that have five or more facilities. This potentially is due to the amount of resources necessary to setup and 
                                  run a whole hospital dedicated to mental health care as opposed to just dedicating a department to this type 
                                  of healthcare at an already established healthcare facility. However, despite the more varied plots, there 
                                  still doesn't appear to be a correlation between the number of facilities and suicide rate."),
                                br(),
                                br(),
                                br(),
                                h3("Income vs. Depression Analysis"),
                                p("Below are two Income vs. Weighted Depression Frequency bar charts.
                                  The first one is 2012 data and the second one is 2018 data."),
                                p(""),
                                h4("2012"),
                                plotlyOutput("income2012chart"),
                                h4("2018"),
                                plotlyOutput("income2018chart"),
                                br(),
                                p("
                                  The 2018 chart overall has greater numbers in weighted frequency than the 2012 chart
                                  for all income categories most likely because of the increase of population in the span of 
                                  five years. 
                                  
                                  We found it interesting that the $100,000+ income group, $50,000-$74,999 income group and the $20,000-$34,999 income have 
                                  very similar frequencies in depression. However, there is still a trend of lower income groups having greater frequencies of
                                  depression than higher income groups.
                                  
                                  
                                  In general for most years, the $75,000-$99,999 income group and the 
                                  $35,000-$49,999 income group have similar weighted frequencies to each other. However, 
                                  in 2018, the weighted frequency of the $75,000-$99,999 income group 
                                  greatly increased and had the second most highest frequency in depression compared to other income groups.
                                  
                                  
                                
                                  One important similarity of both the 2012 and 2018 charts is that
                                  the group making the lowest income of less than $20,000 has the highest
                                  weighted frequency of adult depression. 
                                  Based on these charts, The lowest income group suffers about 2 to 2.46 times more frequently from
                                  adult depression than the highest income group ($100,000+). Living with a low-income salary
                                  is known the be very stressful emotionally and physically. Working long and tiring hours, trying to keep
                                  food on the plate, paying expensive bills for rent, medicine, education, internet, and more are all extremely
                                  stressful factors that contribute to worsening depression for low-income individuals and families. For those making
                                  less than $20,000 annually, this may mean an individual is unemployed, homeless, doesn't have access to healthcare or an education,
                                  which not only endangers a person's mental health, but also physical health. 
                                  Living in the low-income class negatively impacts an individual's mental health so greatly
                                  because of the lack of resources and basic human rights every person should have. 
                                  ")
                                
                                
                                ) 
)

# user interface variable that holds all of the pages presented in shiny
ui <- fluidPage(
  navbarPage(
      "Exploring Mental Health Correlations"
  ,
    introduction_view,
    facilities_view,
    income_view,
    summary_view
  )
)