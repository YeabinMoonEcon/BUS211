library(tidyverse)
setwd("~/Documents/ibs_course/BUS211/data")

dataset <- read_csv('pima-indians-diabetes.csv', col_names = FALSE)
data <- dataset[,1:8]
data 

library(caret)
process <- preProcess(as.data.frame(data), method=c("range"))

norm_scale <- predict(process, as.data.frame(data))
summary(norm_scale)

b <- as.data.frame(scale(data))
summary(b)
