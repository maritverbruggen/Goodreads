library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(gplot)
library(SciViews)
install.packages('sjmisc')
library(sjmisc)
library(fixest)

#read data 
rm(reviews)
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")
View(ra_gw)


#how many ratings in giveaway set before and after giveaway
sum(ra_gw$giveaway_after == "1")
sum(ra_gw$giveaway_after == "0")

#convert rating time and giveaway end date variable
ra_gw$time <- as.Date(ra_gw$time)
ra_gw$giveaway_end_date <- as.Date(ra_gw$giveaway_end_date)

#divide rating time in year, month and day variables
ra_gw$year <- format(ra_gw$time, format="%Y")
ra_gw$month <- format(ra_gw$time, format="%Y-%m")
ra_gw$day <- format(ra_gw$time, format="%Y-%m-%d")

#add variable that indicates days since giveaway 
ra_gw$days_since_gw <- ra_gw$time - ra_gw$giveaway_end_date

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
