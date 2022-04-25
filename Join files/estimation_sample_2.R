library(dplyr)
library(tidyverse)

rm(list=ls())
memory.limit(size=1000000)

#read reviews file 
reviews <- read.csv("../Datasets/reviews_df.csv")
giveaways <- read.csv("../Datasets/giveaways_df.csv")

#transform time variable in reviews data set
reviews$time <- as.Date(reviews$time)
min(reviews$time)

#review texts for how many unique books? 
df_uniq <- unique(reviews$book_id)
length(df_uniq)

#merge files 
re_gw <- reviews %>% inner_join(giveaways, by="book_id")


#create dummy variable for whether review was posted before or after giveaway 
re_gw$giveaway_end_date <- as.Date(re_gw$giveaway_end_date)
re_gw$release_date <- as.Date(re_gw$release_date)

re_gw$giveaway_after <- ifelse(re_gw$time > re_gw$giveaway_end_date, 1, 0)
re_gw$days_since_publication <- re_gw$time - re_gw$release_date
re_gw$days_since_publication <- str_replace(re_gw$days_since_publication, " days", "")

re_gw$days_since_publication <- as.numeric(re_gw$days_since_publication)

re_gw_pre <- re_gw %>% filter(giveaway_after == "0")
mean(re_gw_pre$days_since_publication)
sd(re_gw_pre$days_since_publication)
min(re_gw_pre$days_since_publication)
max(re_gw_pre$days_since_publication)

re_gw_post <- re_gw %>% filter(giveaway_after == "1")
mean(re_gw_post$days_since_publication)
sd(re_gw_pre$days_since_publication)
min(re_gw_pre$days_since_publication)
max(re_gw_pre$days_since_publication)

fwrite(re_gw, "../Estimation_samples/review_giveaway_df.csv")

