# Set up
library(dplyr)
library(ggplot2)
library(tidyverse)
library(plotly)

# Load data
adult_depression <- read.csv('data/adult-depression-lghc-indicator-24.csv')
age_standardized_rates <- read.csv('data/archive/Age-standardized suicide rates.csv')
crude_rates <- read.csv('data/archive/Crude suicide rates.csv')
facilities <- read.csv('data/archive/Facilities.csv')
human_resources <- read.csv('data/archive/Human Resources.csv')
country_continents <- read.csv('data/countryContinent.csv')


#cleaning up some of the data 

country_continents <- country_continents %>%
  rename('Country' = country)

#took all years out of age standardized except 2016 bc all the other datasets
#from kaggle only have data from 2016
age_standardized_2016 <- age_standardized_rates %>%
  select(Country:X2016)

#adding continents onto our data
continents_age_standardized <- merge(age_standardized_2016, country_continents,
                                     by = "Country")
continents_age_standardized <- continents_age_standardized %>%
  select(-code_2, -code_3, -country_code, -iso_3166_2, -sub_region,
         -sub_region_code, -region_code)

#merged the age standardized rates for 2016 with the data about the facilities 
#so it is easier for us to look at the numbers for each country
age_standardized_facilities <- merge(continents_age_standardized,
                                          facilities, by = "Country")

#essentially the same as above but with the human resources
age_standardized_hr <- merge(continents_age_standardized,
                                     human_resources, by = "Country")


#Distribution of Variables

#suicide rates

suicide_mean_by_sex <- age_standardized_facilities %>%
  select('Country', 'Sex', 'X2016') %>%
  rename('suicide_rates' = X2016) %>%
  group_by(Sex) %>%
  summarize(max(suicide_rates), min(suicide_rates), mean(suicide_rates))

suicide_mean_by_country <- age_standardized_facilities %>%
  select('Country', 'Sex', 'X2016') %>%
  rename('suicide_rates' = X2016) %>%
  group_by(Country) %>%
  summarize(mean(suicide_rates))

#Relationships Between Variables

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


ad_2018_income_plot <- ggplot() + geom_col(data = ad_2018_income, 
                                           aes(x = Strata.Name_Income, y = Weighted.Frequency_Income, fill = "#C06C84")) + 
  coord_flip() +
  labs(x = "Income", y = "Weighted Frequency", 
       title = "2018 Income vs. Weighted Frequency of Adult Depression (CA)") +
  theme(legend.position = "none")

ad_2018_income_plotly <- ggplotly(ad_2018_income_plot)

options(scipen=5) #force no E (scientific notation) in values

# The relationship between the suicidal rates and mental hospital rates by Country in 2016
country_mental_hospital <- age_standardized_facilities %>% 
  group_by(Country) %>% 
  summarise(X2016 = mean(X2016), mental_hospitals = mean(Mental._hospitals)) %>% 
#  filter(Country != "Japan") %>% 
  filter(!is.na(mental_hospitals))

country_mental_hospital_plotly <- plot_ly(
  data = country_mental_hospital,
  x = ~mental_hospitals,
  y = ~X2016,
  color = ~Country,
  Type = "scatter",
  Mode = "markers"
) %>% 
  layout(
    title = "Suicidal rates vs. Mental hospital rates by Country in 2016",
    yaxis = list(title = "Suicidal Rates"),
    xaxis = list(title = "Mental Hospital Rates")
  )
