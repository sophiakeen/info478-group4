#server.R

library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)


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

#Load Data
age_standardized_rates <- read.csv('data/archive/Age-standardized suicide rates.csv')
crude_rates <- read.csv('data/archive/Crude suicide rates.csv')
facilities <- read.csv('data/archive/Facilities.csv')
human_resources <- read.csv('data/archive/Human Resources.csv')
country_continents <- read.csv('data/countryContinent.csv')

# The relationship between the suicidal rates and mental hospital rates by Country in 2016
country_mental_hospital <- age_standardized_facilities %>% 
  group_by(Country) %>%
  # rename('suicide_rates' = 'X2016') %>%
  summarise(X2016 = mean(X2016), mental_hospitals = mean(Mental._hospitals), 
            health_units = mean(health_units), outpatient_facilities = mean(outpatient._facilities))


#Define server logic
server <- function(input, output) {
  
  #Mental Hospitals Page
  output$country_facilities_plotly <- renderPlotly({
    # country_mental_hospital_plotly <- plot_ly(
    #   data = country_mental_hospital,
    #   x = input$radio,
    #   y = ~X2016,
    #   color = ~Country,
    #   Type = "scatter",
    #   Mode = "markers"
    # ) %>% 
    #   layout(
    #     title = "Suicidal rates vs. Facilities rates by Country in 2016",
    #     yaxis = list(title = "Suicidal Rates"),
    #     xaxis = list(title = "Facilities Rates")
    #   )
    # 
    # ggplotly(country_mental_hospital_plotly)
    
    url_data <- a("Mental Health and Suicide Rates dataset acessed through Kaggle", href="https://www.kaggle.com/twinkle0705/mental-health-and-suicide-rates?select=Age-standardized+suicide+rates.csv")
    output$tab_url <- renderUI({
      tagList( url_data)
    })
    
    country_facilities_plotly <- ggplot(data = country_mental_hospital, aes_(x = as.name(input$radio), y = as.name("X2016"))) +
      geom_point(size = 1) +
      labs(y = "Suicidal Rates", x = paste(input$radio), title = "Suicidal rates vs. Facilities rates by Country in 2016") +
      scale_color_gradient(low="blue", high="red")
    
    ggplotly(country_facilities_plotly)
    
  })

  
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
  #Mental Hospitals
  output$mentalhospitals <- renderPlotly({
    suicide_mh <- age_standardized_facilities %>%
      #select(Country, X2016, Mental._hospitals) %>%
      group_by(Country) %>%
      summarise(X2016 = mean(X2016), mental_hospitals = mean(Mental._hospitals))
    
      mentalhospitals_plot <- ggplot(data = country_mental_hospital, aes_(x = as.name("mental_hospitals"), y = as.name("X2016"))) +
        geom_point(size = 1) +
        labs(y = "Suicidal Rates", x = "Mental Hospitals", title = "Suicidal rates vs. Mental Hospital rates by Country in 2016")
      
      ggplotly(mentalhospitals_plot) 
  })
  
  #Outpatient Facilities
  output$outpatientfacilites <- renderPlotly({
    suicide_opf <- age_standardized_facilities %>%
      #select(Country, X2016, outpatient._facilities) %>%
      group_by(Country) %>%
      summarise(X2016 = mean(X2016), outpatient_facilites = mean(outpatient._facilities))
    
      outpatientfacilities_plot <- ggplot(data = country_mental_hospital, aes_(x = as.name("outpatient_facilities"), y = as.name("X2016"))) +
        geom_point(size = 1) +
        labs(y = "Suicidal Rates", x = "Outpatient Facilities", title = "Suicidal rates vs. Outpatient Facilities rates by Country in 2016")

      ggplotly(outpatientfacilities_plot) 
  })
  
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

