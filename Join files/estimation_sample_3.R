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
similar_review <- read.csv("../Datasets/similar_review.csv")
similar_review <- similar_review %>% filter(similar_book_id %in% similar$similar_book_id)
similar_ratings <- similar %>% left_join(similar_review, by="similar_book_id")

rm(similar)
rm(similar_review)


similar_ratings <- similar_ratings %>% select(focal_book_id=focal_book_id.x, similar_book_id, title=title.x, reviews, rating, average.rating, publication_date, treated, new_review_id, ratings, time)

#create subset of book_info data set
book_info <- read.csv("../Datasets/book_df.csv")
book <- book_info %>% select(focal_book_id=id, title, reviews=text_reviews_count, rating=ratings_count, average.rating=average_rating, publication_date=book_publication_date)
book$treated <- "1"
book <- book %>% filter(focal_book_id %in% similar_ratings$focal_book_id)

ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
ratings <- ratings %>% select(focal_book_id=book_id, new_review_id, ratings, time)


#join ratings to book data set 
book_ratings <- book %>% left_join(ratings, by="focal_book_id")
rm(book)
rm(ratings)

#only select focal book id and similar book id to append to book set
similar_append <- similar %>% select(focal_book_id, similar_book_id)
rm(similar)

#join similar_book_id to book set 
book_complete <- similar_append %>% right_join(book_ratings, by="focal_book_id")
rm(book_ratings)
rm(similar_append)

#check correctness of columns 
names(book_complete)
names(similar_ratings)
book_similar_rating <- rbind(book_complete,similar_ratings)

#add giveaway information to did estimation sample 
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
giveaways <- giveaways %>% filter(book_id %in% book_similar_rating$focal_book_id)
giveaways <- giveaways %>% select(focal_book_id = book_id, copy_n, request_n, giveaway_start_date, giveaway_end_date, listedby_book_n, listedby_friend_n)

book_similar_rating_giveaway <- book_similar_rating %>% left_join(giveaways, by="focal_book_id")
rm(giveaways)
rm(book_similar_rating)
rm(book_total)


#save the data 
fwrite(book_similar_rating_giveaway, "../Estimation_samples/did_book_similar_ratings.csv")
