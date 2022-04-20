library(dplyr)
library(tidyverse)
library(R.utils)
library(data.table)

#read similar files 
rm(list=ls())

memory.limit()
memory.limit(size=1000000)
memory.limit()


similar_map <- read.csv("../Datasets/similar_map_thesis.csv")
similar_meta <- read.csv("../Datasets/similar_meta_thesis.csv")
giveways <- read.csv("../Datasets/giveaways_thesis.csv")
book_info <- read.csv("../Datasets/book_df_cleanPublisher.csv")
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
similar_review <- read.csv("../Datasets/similar_review.csv")

#delete more than 1 similar books in similar map file 
similar_map <-similar_map[!duplicated(similar_map$focal_book_id), ] 

#join similar_map and similar_meta 
similar <- similar_map %>% inner_join(similar_meta, by="similar_book_id")

#make sure books only appear once 
similar <- similar %>% distinct()

#delete variables not used in further analysis
similar <- similar %>% select(focal_book_id, similar_book_id, title=title.x, reviews, rating, average.rating, publication_date)
similar$treated <- "0"

#add similar_ratings file 
similar_review <- similar_review %>% filter(similar_book_id %in% similar$similar_book_id)
similar_ratings <- similar %>% left_join(similar_review, by="similar_book_id")

names(similar_ratings)
similar_ratings <- similar_ratings %>% select(focal_book_id=focal_book_id.x, similar_book_id, title=title.x, reviews, rating, average.rating, publication_date, treated, new_review_id, ratings, time)

#create subset of book_info data set 
book <- book_info %>% select(focal_book_id=id, title, reviews=text_reviews_count, rating=ratings_count, average.rating=average_rating, publication_date=book_publication_date)
book$treated <- "1"
ratings <- ratings %>% select(focal_book_id=book_id, new_review_id, ratings, time)

#filter books data set for whether books appear in similar data set
book <- book %>% filter(focal_book_id %in% similar_ratings$focal_book_id)

#join ratings to book data set 
book_ratings <- book %>% left_join(ratings, by="focal_book_id")
rm(book_info)

#only select focal book id and similar book id to append to book set
similar_append <- similar %>% select(focal_book_id, similar_book_id)

#join similar_book_id to book set 
book_complete <- similar_append %>% right_join(book_ratings, by="focal_book_id")
View(book_complete)

giveaways <- read.csv("../Datasets/giveaways_thesis.csv")

giveaways <- giveaways %>% filter(book_id %in% book_ratings$focal_book_id)
giveaways <- giveaways %>% select(focal_book_id = book_id, copy_n, request_n, giveaway_start_date, giveaway_end_date, listedby_book_n, listedby_friend_n)

#add giveaway information to did estimation sample 
book_complete <- book_complete %>% right_join(giveaways, by="focal_book_id")

#join data sets! 
est_3 <- rbind(book_complete,similar_ratings)

#save the data 
fwrite(did, "../Estimation_samples/similar_book_ratings.csv")
