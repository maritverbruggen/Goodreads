library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(gplot)
library(SciViews)
library(sjmisc)
library(fixest)

rm(list=ls())
memory.limit(size=1000000)

#read data 
reviews <- read.csv("../Estimation_samples/review_giveaway_df.csv")

reviews$time <- as.Date(reviews$time)
reviews$giveaway_end_date <- as.Date(reviews$giveaway_end_date)

reviews <- reviews %>% filter(reviews$time >= "2015-01-01")

reviews$month <- format(reviews$time, "%Y-%m")



#panel fixed effect regression 
#fixed effect analysis on sample 
gravity_subfe = list()
all_FEs = c("book_id", "month")
for(i in 0:2){
    gravity_subfe[[i+1]] = feols(word_count ~ giveaway_after, reviews, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~book_id)


