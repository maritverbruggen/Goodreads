library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

rm(list=ls())
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")
View(ra_gw)

ra_gw$time <- as.Date(ra_gw$time)
ra_gw$giveaway_end_date <- as.Date(ra_gw$giveaway_end_date)

ra_gw$giveaway_dummy <- ifelse(ra_gw$time >= ra_gw$giveaway_end_date, 1,0)

install.packages("fixest")
library(fixest)

m1 <- feols(ratings ~ giveaway_dummy | book_id, data=ra_gw)
summary(m1)
m2 <- feols(ratings ~ giveaway_dummy | book_id, data=ra_gw)
summary(m2)
