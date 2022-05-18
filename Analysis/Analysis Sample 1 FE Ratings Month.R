library(haven)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)
library(data.table)

rm(list=ls())
memory.limit(size=1000000)

ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")

ra_gw$time <- as.Date(ra_gw$time)
ra_gw$giveaway_end_date <- as.Date(ra_gw$giveaway_end_date)
ra_gw <- ra_gw %>% filter(ra_gw$time >= "2015-01-01")


ra_gw$month <- format(ra_gw$time, "%Y-%m")
ra_gw$gw_month <- format(ra_gw$giveaway_end_date, "%Y-%m")


ratings_count <- ra_gw %>% count(book_id, month, gw_month)
View(ratings_count)

ratings_count$post <- ifelse(ratings_count$month > ratings_count$gw_month, "1", "0")
ratings_count$post <- as.factor(ratings_count$post)
head(ratings_count)

#panel fixed effect regression 
m1 <- feols(n ~ post | book_id + month, ratings_count)
etable(m1)
