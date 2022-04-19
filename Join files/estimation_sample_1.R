library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)
library(data.table)

ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
View(ratings)
View(giveaways)

#transform time variable in ratings data set
ratings$time <- str_replace(ratings$time, ",","")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- as.Date(ratings$time, format="%b/%d/%Y")

#remove ratings before 2007 
sum(ratings$time < as.Date("2007-01-01"))
ratings <- ratings[order(ratings$time),]
ratings <- subset(ratings, time >= as.Date("2007-01-01"))


#merge ratings data set with giveaways data set 
ra_gw <- ratings %>% inner_join(giveaways, by="book_id")
View(ra_gw)

#delete variables not of use in analysis 
ra_gw <- subset(ra_gw, select=c(book_id, new_review_id, ratings, time, giveaway_id, book_title, release_date, copy_n, request_n, giveaway_start_date, giveaway_end_date, listedby_name, listedby_book_n, listedby_friend_n))

#ratings before or after giveaway dummy variable 
ra_gw$giveaway_after <- ifelse(ra_gw$time > ra_gw$giveaway_end_date, 1, 0)

#save file 
ra_gw <- as.data.frame(ra_gw)

author <- read.csv("../Datasets/author_df.csv")
author <- author %>% select(book_id, author_average_rating)
ra_gw <- ra_gw %>% left_join(author, by="book_id")

fwrite(ra_gw, "../Estimation_samples/rating_giveaway_df.csv")

