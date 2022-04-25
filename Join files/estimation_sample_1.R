library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)
library(data.table)


rm(list=ls())
memory.limit(size=1000000)

ratings <- read.csv("../Datasets/ratings_df.csv")
giveaways <- read.csv("../Datasets/giveaways_df.csv")
head(ratings)

ratings$time <- as.Date(ratings$time)
min(ratings$time)
head(giveaways)


#merge ratings data set with giveaways data set 
ra_gw <- ratings %>% inner_join(giveaways, by="book_id")
df_uniq <- unique(ratings$book_id)
length(df_uniq)

head(ra_gw)

ra_gw$giveaway_end_date <- as.Date(ra_gw$giveaway_end_date)

#ratings before or after giveaway dummy variable 
ra_gw$giveaway_after <- ifelse(ra_gw$time > ra_gw$giveaway_end_date, 1, 0)

#divide rating time in month variable
ra_gw$month <- format(ra_gw$time, format="%m")
table(ra_gw$giveaway_after)

#add variable that indicates days since publication 
ra_gw$release_date <- as.Date(ra_gw$release_date)
ra_gw$days_since_publication <- ra_gw$time - ra_gw$release_date
ra_gw$days_since_publication <- str_replace(ra_gw$days_since_publication, " days", "")
ra_gw$days_since_publication <- as.numeric(ra_gw$days_since_publication)

ra_gw_pre <- ra_gw %>% filter(giveaway_after =="0")
mean(ra_gw_pre$days_since_publication)
sd(ra_gw_pre$days_since_publication)
min(ra_gw_pre$days_since_publication)
max(ra_gw_pre$days_since_publication)

ra_gw_post <- ra_gw %>% filter(giveaway_after == "1")
mean(ra_gw_post$days_since_publication)
sd(ra_gw_post$days_since_publication)
min(ra_gw_post$days_since_publication)
max(ra_gw_post$days_since_publication)


#write file
fwrite(ra_gw, "../Estimation_samples/rating_giveaway_df.csv")

