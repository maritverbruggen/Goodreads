library(readr)
library(dplyr)

rm(list=ls())
memory.limit(size=1000000)

rm(book)
ratings <- read.csv("../Raw Datasets/ratings_df.csv")
giveaways <- read.csv("../Datasets/giveaways_df.csv")

ratings <- ratings %>% filter(book_id %in% giveaways$book_id)
uniq_df <- unique(ratings$book_id)
length(uniq_df)

ratings <- ratings %>% select(book_id, new_review_id, ratings, time)
ratings$time <- str_replace(ratings$time, ",", "")
ratings$time <- str_replace_all(ratings$time, " ", "-")
ratings$time <- as.Date(ratings$time, "%b-%d-%Y")

ratings <- ratings %>% filter(time >= "2007-01-01")

fwrite(ratings, "../Datasets/ratings_df.csv")

