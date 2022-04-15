library(dplyr)
library(tidyverse)

#read reviews file 
reviews <- read.csv("../Datasets/reviews_thesis_text.csv")

#delete reviews without text 
reviews <- subset(reviews, reviews$text != "")

#transform time variable in reviews data set
reviews$time <- as.Date(reviews$time)

#delete all reviews before 01-01-2007
reviews <- subset(reviews, reviews$time >= "2007-01-01")

#review texts for how many unique books? 
df_uniq <- unique(reviews$book_id)
length(df_uniq)

#merge files 
re_gw <- reviews %>% inner_join(giveaways, by="book_id")

#delete variables not used for analysis 
re_gw <- subset(re_gw, select=c(book_id, ratings, time, text, giveaway_id, book_title, release_date, copy_n, request_n, giveaway_start_date, giveaway_end_date, listedby_name, listedby_book_n, listedby_friend_n))

#create dummy variable for whether review was posted before or after giveaway 
re_gw$giveaway_after <- ifelse(re_gw$time > re_gw$giveaway_end_date, 1, 0)

#save file 
re_gw <- as.data.frame(re_gw)
fwrite(re_gw, "../Estimation_samples/review_giveaway_df.csv")

