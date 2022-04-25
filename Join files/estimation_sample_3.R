library(dplyr)
library(tidyverse)
library(R.utils)
library(data.table)

#read similar files 
rm(list=ls())

memory.limit()
memory.limit(size=1000000)
memory.limit()



#join similar_map and similar_meta 
similar <- read.csv("../Datasets/similar_info.csv")
  
#make sure books only appear once 
similar <- similar %>% distinct()
rm(similar_map)
rm(similar_meta)
names(similar)

similar$treated <- "0"

#add similar_ratings file 
similar_review <- read.csv("../Datasets/similar_ratings_df.csv")
similar_review <- similar_review %>% filter(similar_book_id %in% similar$similar_book_id)
similar_ratings <- similar %>% inner_join(similar_review, by="similar_book_id")

similar_ratings <- similar_ratings %>% select(focal_book_id=focal_book_id.x, similar_book_id, title=title.x, reviews, rating, average.rating, publication_date, treated, new_review_id, ratings, time)
df_uniq <- unique(similar_ratings$similar_book_id)
length(df_uniq)

#create subset of book_info data set
book_info <- read.csv("../Datasets/book_df.csv")
names(book_info)
book <- book_info %>% select(focal_book_id=id, title, reviews=text_reviews_count, rating=ratings_count, average.rating=average_rating, publication_date=book_publication_date)
book$treated <- "1"
book <- book %>% filter(focal_book_id %in% similar_ratings$focal_book_id)


ratings <- read.csv("../Datasets/ratings_df.csv")
ratings <- ratings %>% select(focal_book_id=book_id, new_review_id, ratings, time)
ratings<- ratings %>% filter(focal_book_id %in% book$focal_book_id)


#join ratings to book data set 
book_ratings <- book %>% inner_join(ratings, by="focal_book_id")
rm(book)
rm(ratings)

#only select focal book id and similar book id to append to book set
similar_append <- similar %>% select(focal_book_id, similar_book_id)
rm(similar)

#join similar_book_id to book set 
book_complete <- similar_append %>% inner_join(book_ratings, by="focal_book_id")
head(book_complete)

#check correctness of columns 
names(book_complete)
names(similar_ratings)
book_similar_rating <- rbind(book_complete,similar_ratings)
rm(similar_append)
rm(ratings_filter)

#add giveaway information to did estimation sample 
giveaways <- read.csv("../Datasets/giveaways_df.csv")
giveaways <- giveaways %>% filter(book_id %in% book_similar_rating$focal_book_id)
names(giveaways)
book_similar_rating_giveaway <- book_similar_rating %>% inner_join(giveaways, by=c("focal_book_id"="book_id"))
head(book_similar_rating_giveaway)

#add post variable 
book_similar_rating_giveaway$post <- ifelse(book_similar_rating_giveaway$time > book_similar_rating_giveaway$giveaway_end_date, 1,0)
sum(book_similar_rating_giveaway$post == "1")
sum(book_similar_rating_giveaway$post == "0")

sum(book_similar_rating_giveaway$treated == "1" & book_similar_rating_giveaway$post == "0")

#save the data 
fwrite(book_similar_rating_giveaway, "../Estimation_samples/est_3.csv")



#descriptive statistics 
did_treat <- book_similar_rating_giveaway %>% filter(treated == "1")
did_nontreat <- book_similar_rating_giveaway %>% filter(treated == "0")

mean(did_treat$ratings)
sd(did_treat$ratings)

mean(did_nontreat$ratings)
sd(did_nontreat$ratings)
