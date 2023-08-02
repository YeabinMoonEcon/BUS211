library(tidyverse)

test <- read_csv('https://raw.githubusercontent.com/jbrownlee/Datasets/master/horse-colic.csv', col_names = FALSE)
test <- read_csv('horse-colic.csv', col_names = FALSE)
glimpse(test)

df <- read_csv('https://raw.githubusercontent.com/jbrownlee/Datasets/master/horse-colic.csv', col_names = FALSE,  na = c("?", NaN))
summary(df)

df %>% replace_na(X4, mean(X4))

glimpse(df)

head(df,20)

NaN

test <- tibble(x = c(1, 2, NA), y = c("a", NA, "b"))
test
test %>% replace_na(list(x = mean(x)))
colSums(is.na(df)) / length(df) 

colSums(is.na(df)) / nrow(df) * 100

nrow(df)




df <- df %>%
  mutate(X1 = replace(X1, is.na(X1), median(X1, na.rm = TRUE)))
