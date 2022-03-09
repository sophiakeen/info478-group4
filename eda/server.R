#server.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
#library(rsconnect)




#income data 
adult_depression <- read.csv('data/adult-depression-lghc-indicator-24.csv')
#How does socioeconomic status level impact prevalence of depression? 

ad_2018 <- adult_depression %>% 
  filter(Year == 2018)
ad_2018_wider <- ad_2018 %>% pivot_wider(names_from = Strata,
                                         values_from = c(Strata.Name, Frequency, Weighted.Frequency,
                                                         Lower.95..CL, Upper.95..CL))

ad_2018_income <- ad_2018_wider %>% select('Year', 'Strata.Name_Income', 'Frequency_Income',
                                           'Weighted.Frequency_Income', 'Lower.95..CL_Income',
                                           'Upper.95..CL_Income')
ad_2018_income <- na.omit(ad_2018_income)

#
ad_wider <- adult_depression %>% pivot_wider(names_from = Strata,
                                             values_from = c(Strata.Name, Frequency, Weighted.Frequency,
                                                             Lower.95..CL, Upper.95..CL))

ad_income <- ad_wider %>% select('Year', 'Strata.Name_Income', 'Frequency_Income',
                                 'Weighted.Frequency_Income', 'Lower.95..CL_Income',
                                 'Upper.95..CL_Income')
ad_income <- na.omit(ad_income)



#Define server logic
server <- function(input, output) {
  
  #Income Page
  #output$incomeheading <- renderText({input$year_input})
  url <- a("Adult Depression (LGHC Indicator) dataset", href="https://healthdata.gov/State/Adult-Depression-LGHC-Indicator-/73c2-5f46")
  output$tab <- renderUI({
    tagList( url)
  })
  output$incomechart <- renderPlotly({
    
    ad_filter_year <- ad_income %>% filter(Year == input$year_input)
    ad_filter_year$Strata.Name_Income <- factor(ad_filter_year$Strata.Name_Income, levels = ad_filter_year$Strata.Name_Income) #orders bar chart by income
    ad_income_plot <- ggplot() + geom_col(data = ad_filter_year, 
                                               aes(x = Strata.Name_Income, y = Weighted.Frequency_Income, fill = Strata.Name_Income)) + 
      coord_flip() +
      labs(x = "Income", y = "Weighted Frequency", 
           title = " Income vs. Weighted Frequency of Adult Depression (CA)") +
      theme(legend.position = "none") +
      scale_y_continuous(labels = function(x) format(x, big.mark = ",",
                                                     scientific = FALSE)) 
    ggplotly(ad_income_plot)
     })
  
  #Conclusion Page
  #2012
  output$income2012chart <- renderPlotly({
    ad_filter_2012 <- ad_income %>% filter(Year == 2012)
    ad_filter_2012$Strata.Name_Income <- factor(ad_filter_2012$Strata.Name_Income, levels = ad_filter_2012$Strata.Name_Income) #orders bar chart by income
    ad_2012_income_plot <- ggplot() + geom_col(data = ad_filter_2012, 
                                               aes(x = Strata.Name_Income, y = Weighted.Frequency_Income, fill = Strata.Name_Income)) + 
      coord_flip() +
      labs(x = "Income", y = "Weighted Frequency", 
           title = " Income vs. Weighted Frequency of Adult Depression (CA)") +
      theme(legend.position = "none") +
      scale_y_continuous(labels = function(x) format(x, big.mark = ",",
                                                     scientific = FALSE)) 
    ggplotly(ad_2012_income_plot)
    
  })
  
  #2018
  output$income2018chart <- renderPlotly({
    ad_filter_2018 <- ad_income %>% filter(Year == 2018)
    ad_filter_2018$Strata.Name_Income <- factor(ad_filter_2018$Strata.Name_Income, levels = ad_filter_2018$Strata.Name_Income) #orders bar chart by income
    ad_2018_income_plot <- ggplot() + geom_col(data = ad_filter_2018, 
                                          aes(x = Strata.Name_Income, y = Weighted.Frequency_Income, fill = Strata.Name_Income)) + 
      coord_flip() +
      labs(x = "Income", y = "Weighted Frequency", 
           title = " Income vs. Weighted Frequency of Adult Depression (CA)") +
      theme(legend.position = "none") +
      scale_y_continuous(labels = function(x) format(x, big.mark = ",",
                                                     scientific = FALSE)) 
    ggplotly(ad_2018_income_plot)
    
  })
  
  
  

  
  
  
  
}

