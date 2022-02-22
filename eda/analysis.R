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


#cleaning up some of the data 

#took all years out of age standardized except 2016 bc all the other datasets
#from kaggle only have data from 2016
age_standardized_2016 <- age_standardized_rates %>%
  select(Country:X2016)

#merged the age standardized rates for 2016 with the data about the facilities 
#so it is easier for us to look at the numbers for each country
age_standardized_facilities <- merge(age_standardized_2016,
                                          facilities, by = "Country")

#essentially the same as above but with the human resources
age_standardized_hr <- merge(age_standardized_2016,
                                     human_resources, by = "Country")

#Distribution of Variables

#Relationships Between Variables

#How does mental healthcare affect suicide rates?

#This section needs to be refined. I just did what I could in the time I had. 
#Sorry. Essentially, I selected mental hospitals specifically to show how the 
#number of mental hospitals affects suicides rates. I wanted to filter so we 
#only got both sexes but I couldn't get it to work. 

mental_hospital_rates <- age_standardized_facilities %>%
  select('Country', 'Sex', 'X2016', 'Mental._hospitals') %>%
  arrange(desc(Mental._hospitals)) %>%
  rename('suicide_rates' = X2016, 'mental_hospitals' = Mental._hospitals)

ggplot(data = mental_hospital_rates, aes(x = suicide_rates, 
                                                     y = mental_hospitals)) + geom_point(shape = 1) +
  labs(x = "Suicide Rates", y = "Mental Hospitals",
       title = "Number of Mental Hospitals vs Suicide Rates")


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


