# Set up
library(dplyr)
library(ggplot2)
library(tidyverse)

# Load data
adult_depression <- read.csv('data/adult-depression-lghc-indicator-24.csv')
age_standardized_rates <- read.csv('data/archive/Age-standardized suicide rates.csv')
crude_rates <- read.csv('data/archive/Crude suicide rates.csv')
facilities <- read.csv('data/archive/Facilities.csv')
human_resources <- read.csv('data/archive/Human Resources.csv')

