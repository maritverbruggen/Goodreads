library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

rm(list=)
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
View(ratings)
View(giveaways)

#clean author en book information file 
ratings <- subset(ratings, select =c(book_id, review_id, new_review_id, ratings, time))
giveaways <- subset(giveaways, select=c(giveaway_id, book_id, copy_n, request_n, giveaway_start_date, giveaway_end_date))

#merge ra_re with giveaways file 
re_gw <- ratings %>% inner_join(giveaways, by="book_id")
View(re_gw)

#change time variable in review_ratings file 
re_gw$time <- str_replace(re_gw$time, ",","")
re_gw$time <- str_replace(re_gw$time, " ", "/")
re_gw$time <- str_replace(re_gw$time, " ", "/")
re_gw$time <- as.Date(re_gw$time, format="%b/%d/%Y")
re_gw$giveaway_end_date <- as.Date(re_gw$giveaway_end_date)

#ratings before or after giveaway dummy variable 
re_gw$giveaway_after <- ifelse(re_gw$time >= re_gw$giveaway_end_date, 1, 0)
View(re_gw)


write.csv(re_gw,"../Datasets/review_giveaway_df.csv", row.names = FALSE)


