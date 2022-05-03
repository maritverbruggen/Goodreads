library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)

rm(list=ls())
memory.limit(size=1000000)

ratings <- read.csv("../Estimation_samples/rating_giveaway_df.csv")

ratings$time <- as.Date(ratings$time)
ratings$giveaway_end_date <- as.Date(ratings$giveaway_end_date)

ratings <- ratings %>% filter(time >= "2015-01-01")

ratings$month <- format(ratings$time, "%Y-%m")
ratings$gw_month <- format(ratings$giveaway_end_date, "%Y-%m")

ratings_count <- ratings %>% count(book_id, month, gw_month)
View(ratings_count)

ratings_count$post <- ifelse(ratings_count$month > ratings_count$gw_month, "1", "0")
View(ratings_count)

#panel fixed effect regression 
#fixed effect analysis on sample 
gravity_subfe = list()
all_FEs = c("book_id", "month")
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(n ~ post, ratings_count, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~book_id)
