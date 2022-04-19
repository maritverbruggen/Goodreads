library(dplyr)
library(tidyverse)

#read similar files 
rm(list=ls())
similar_map <- read.csv("../Datasets/similar_map_thesis.csv")
similar_meta <- read.csv("../Datasets/similar_meta_thesis.csv")
giveways <- read.csv("../Datasets/giveaways_thesis.csv")
book_info <- read.csv("../Datasets/book_df_cleanPublisher.csv")

#delete more than 1 similar books 
similar_map <-similar_map[!duplicated(similar_map$focal_book_id), ] 
View(similar_map)

#join similar_map and similar_meta 
similar <- similar_map %>% inner_join(similar_meta, by="similar_book_id")
View(similar)

#delete variables not used in further analysis
similar <- similar %>% select(focal_book_id, title=title.x, reviews, rating, average.rating, publication_date)
similar$treated <- "0"

#create subset of book_info data set 
book <- book_info %>% select(focal_book_id=id, title, reviews=text_reviews_count, rating=ratings_count, average.rating=average_rating, publication_date=book_publication_date)
book$treated <- "1"

#join data sets 
book <- filter(book, focal_book_id %in% similar$focal_book_id)

est_3 <- rbind(book,similar)
View(est_3)

#save the data 
fwrite(est_3, "../Estimation_samples/similar_books.csv")
