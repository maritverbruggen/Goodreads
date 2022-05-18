library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(gplot)
library(SciViews)
library(sjmisc)
library(fixest)
library(data.table)
library(dplyr)
library(fixest)

rm(list=ls())
memory.limit(size=1000000)

#read data 
reviews <- read.csv("../Estimation_samples/review_giveaway_df.csv")

reviews$time <- as.Date(reviews$time)
reviews$giveaway_end_date <- as.Date(reviews$giveaway_end_date)
reviews <- reviews %>% filter(reviews$time >= "2015-01-01")


re_gw$month <- format(re_gw$time, "%Y-%m")
re_gw$gw_month <- format(re_gw$giveaway_end_date, "%Y-%m")

reviews_count <- re_gw %>% count(book_id, month, gw_month)

reviews_count$post <- ifelse(reviews_count$month > reviews_count$gw_month, "1", "0")

m1 <- feols(n ~ post | book_id + month, reviews_count)

tab_model(m1,
          show.ci = FALSE, 
          dv.labels = c("Fixed Effects Regression"),
          pred.labels = c("Post Giveaway"),
          title = "Effect of Giveaways on Number of Reviews", 
          show.intercept = TRUE)
