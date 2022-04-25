library(readr)
library(dplyr)

rm(list=ls())

similar_meta <- read.csv("../Raw Datasets/similar_meta_df.csv")
similar_map <- read.csv("../Raw Datasets/similar_map_df.csv")
similar_ratings <- read.csv("../Datasets/similar_ratings_df.csv")

#delete more than 1 similar books in similar map file 
similar_map <-similar_map[!duplicated(similar_map$focal_book_id), ] 
similar_meta <- similar_meta %>% filter(similar_book_id %in% similar_map$similar_book_id)
similar_meta <- similar_meta %>% distinct()

head(similar_map)
names(similar_map)

names(similar_meta)

similar_map <- similar_map %>% select(focal_book_id, similar_book_id)
similar_meta <- similar_meta %>% select(similar_book_id, title, reviews, rating, average.rating, publication_date)

similar <- similar_map %>% inner_join(similar_meta, by="similar_book_id")
head(similar)
names(similar)

fwrite(similar, "../Datasets/similar_info.csv")
