library(haven)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)
library(sjlabelled)

#read data 
rm(list=ls())
memory.limit(size=1000000)
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")


#remove data before 2015 
ra_gw$time <- as.Date(ra_gw$time) 
ra_gw <- ra_gw %>% filter(time >= "2015-01-01")

#create month variable 
ra_gw$month <- format(ra_gw$time, "%Y-%m")


#correct data structure
ra_gw$ratings <- as.numeric(ra_gw$ratings)
ra_gw$book_id <- as.factor(ra_gw$book_id)
ra_gw$month <- as.factor(ra_gw$month)
ra_gw$post <- as.factor(ra_gw$giveaway_after)

#fixed effect analysis on sample 

m1 <- feols(ratings ~ post | book_id+ month, ra_gw)
etable(m1)


