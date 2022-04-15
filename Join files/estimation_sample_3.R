library(dplyr)
library(tidyverse)

#read similar files 
rm(list=ls())
similar_map <- read.csv("../Datasets/similar_map_thesis.csv")
similar_meta <- read.csv("../Datasets/similar_meta_thesis.csv")
giveways <- read.csv("../Datasets/giveaways_thesis.csv")
book_info <- read.csv("../Datasets/book_df_cleanPublisher.csv")

View(book_info)
View(similar_map)
View(similar_meta)

#delete focal books that are not valuable 
similar_map <-similar_map[!duplicated(similar_map$focal_book_id), ] 
View(similar_map)

#join similar_map and similar_meta 
similar <- similar_map %>% inner_join(similar_meta, by="similar_book_id")
View(similar)

#match the book information of focal books too 
focal_books <- subset(similar, select=focal_book_id)
View(focal_books)

#delete variables not used in further analysis
similar <- subset(similar, select=c(focal_book_id, similar_book_id, reviews, rating, average.rating, publication_day))
book <- subset(book_info, select = c(id, ratings_count, text_reviews_count, average_rating,book_publication_date))
focal_books_meta <- focal_books %>% inner_join(book, by=c("focal_book_id"="id"))
View(focal_books_meta)
View(similar)

#save this data 
fwrite(similar, "../Estimation_samples/similar_books.csv")
fwrite(focal_books_meta, '../Estimation_samples/focal_books.csv')
