
library(caret)
library(tidyverse)
setwd("~/Documents/ibs_course/BUS211/data")









dc_listings <- read_csv('tidy_dc_airbnb.csv')
names(dc_listings)

train_indices <- createDataPartition(y = dc_listings$tidy_price ,p = 0.7, list = F)

train_listings <- dc_listings[train_indices,]
test_listings <- dc_listings[-train_indices,]
