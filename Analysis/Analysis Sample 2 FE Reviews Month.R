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
reviews$gw_month <- format(reviews$giveaway_end_date, "%Y-%m")

reviews_count <- reviews %>% count(book_id, month, gw_month)
head(reviews_count)

reviews_count$post <- ifelse(reviews_count$month > reviews_count$gw_month, "1", "0")

head(reviews_count)
View(reviews_count)


#panel fixed effect regression 
#fixed effect analysis on sample 
gravity_subfe = list()
all_FEs = c("book_id", "month")
for(i in 0:2){
    gravity_subfe[[i+1]] = feols(n ~ post, reviews_count, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~book_id)
