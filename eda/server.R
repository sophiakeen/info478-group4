#server.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
#library(rsconnect)




#data 
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


#options(scipen=5) #force no E (scientific notation) in values

#Define server logic
server <- function(input, output) {
  
  output$incomechart <- renderPlotly({
    
    ad_2018_income_plot <- ggplot() + geom_col(data = ad_2018_income, 
                                               aes(x = Strata.Name_Income, y = Weighted.Frequency_Income, fill = "#C06C84")) + 
      coord_flip() +
      labs(x = "Income", y = "Weighted Frequency", 
           title = "2018 Income vs. Weighted Frequency of Adult Depression (CA)") +
      theme(legend.position = "none")
    
    #ad_2018_income_plotly <- ggplotly(ad_2018_income_plot)
    ggplotly(ad_2018_income_plot)
    
    
  })
}

