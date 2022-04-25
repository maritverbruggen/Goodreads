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
memory.limit(size=1000000)
rm(list=ls())
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")

names(ra_gw)
ra_gw$ratings <- as.numeric(ra_gw$ratings)
ra_gw$giveaway_after <- as.factor(ra_gw$giveaway_after)
ra_gw$month <- as.factor(ra_gw$month)
ra_gw$book_id <- as.factor(ra_gw$book_id)

#fixed effect analysis on sample 
gravity_subfe = list()
all_FEs = c("book_id", "month")
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(ratings ~ giveaway_after*days_since_publication, ra_gw, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~book_id)



