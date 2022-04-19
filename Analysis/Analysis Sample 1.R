library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(gplot)
library(SciViews)
library(sjmisc)
library(fixest)

#read data 
rm(list=ls())

ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")

#create sample to be able to perform analyses
ra_gw_sample <- ra_gw[sample(nrow(ra_gw),100000),]

#fixed effect analysis on sample 

#simple fixed effect analysis 
m1 <- feols(ratings ~ giveaway_after, data=ra_gw_sample)
summary(m1)

m2 <- feols(ratings ~ giveaway_after | book_id, data=ra_gw_sample)
summary(m2)

m3 <- feols(ratings ~ giveaway_after | book_id + request_n, data = ra_gw_sample)
summary(m3)

m4 <- feols(ratings ~ giveaway_after | book_id + request_n + copy_n + listedby_friend_n + factor(month), data=ra_gw_sample)
summary(m4)
etable(m4)
