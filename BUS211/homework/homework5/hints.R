library(tidyverse)
setwd("~/Library/CloudStorage/Box-Box/data/SG/Places")
place <- read_csv('your_data_aug_11_2022_1107am.csv')
setwd("~/Library/CloudStorage/Box-Box/data/SG/Patterns")
patterns <- read_csv('your_data_sep_15_2022_0304pm.csv')


temp <- place %>% select(placekey, naics_code)

df<-patterns %>% 
  left_join(temp, by ='placekey')

glimpse(df)
# find there are three data types

df %>% summarise_if(is.numeric, var, na.rm = T)
# numeric columns all have positive variance, so no unique values

# date_range_start and date_range_end are time variables

# Now focus on the character columns
df_cha <- df %>%
  select_if(is.character) 

# Note that it has 20 columns
ncol(df_cha)

df_cha %>% count()


unique(df_cha$city)

unique(df_cha)

names(df_cha)

df_cha %>% count(placekey) %>% 


df %>% summarise_if(is.character, var)


glimpse(df)


  
df_numeric


df %>% summarise_if(is.numeric, var) %>% names()

df$distance_from_home

glimpse(df)
