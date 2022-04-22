library(readr)    
library(dplyr)    
library(tidyr)     
library(tidygraph) 
library(ggraph)
library(arsenal)


rm(list=ls())

memory.limit()


did <- read.csv("../Estimation_samples/est_3.csv")

#create table 
table_1 <- tableby(treated ~., data=did)
summary(table_1, title = "Descriptive Statistics Estimation Sample 3")


