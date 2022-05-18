library(haven)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)

rm(list=ls())
memory.limit(size=1000000)

#read data 
reviews <- read.csv("../Estimation_samples/review_giveaway_df.csv")

reviews$time <- as.Date(reviews$time)

reviews <- reviews %>% filter(reviews$time >= "2015-01-01")

reviews$month <- format(reviews$time, "%Y-%m")

#panel fixed effect regression 

m1 <- feols(word_count ~ giveaway_after | book_id + month, reviews)

tab_model(m1,
          show.ci = FALSE, 
          dv.labels = c("Fixed Effects Regression"),
          pred.labels = c("Post Giveaway"),
          title = "Effect of Giveaways on Review Length", 
          show.intercept = TRUE)


