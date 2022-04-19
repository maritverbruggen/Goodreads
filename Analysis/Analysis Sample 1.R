library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
install.packages("gplot")
library(gplot)

rm(reviews)
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")
View(ra_gw)

ra_gw$time <- as.Date(ra_gw$time)
ra_gw$giveaway_end_date <- as.Date(ra_gw$time)

ra_gw$year <- format(ra_gw$time, format="%Y")
ra_gw$month <- format(ra_gw$time, format="%Y-%m")
ra_gw$day <- format(ra_gw$time, format="%Y-%m-%d")
View(ra_gw)

ra_gw$days_since_gw <- ra_gw$time - ra_gw$giveaway_end_date

#how many ratings in giveaway set before and after giveaway
sum(ra_gw$giveaway_after == "1")
sum(ra_gw$giveaway_after == "0")

View(ra_gw)
ra_gw$giveaway_after <- as.factor(ra_gw$giveaway_after)
ra_gw$ratings <- as.numeric(ra_gw$ratings)
ra_gw$time <- as.Date(ra_gw$time)
ra_gw$copy_n <- as.numeric(ra_gw$copy_n)
ra_gw$request_n <- as.numeric(ra_gw$request_n)







#fixest package
install.packages("SciViews")
library(SciViews)

model_1 <- lm(ln(ratings) ~ giveaway_after + copy_n + request_n + time, ra_gw)
summary(model_1, vcov = "twoway")