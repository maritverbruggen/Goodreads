library(readr)
library(haven)
library(dplyr)

rm(list=ls())
memory.limit(size=1000000)

#load book data
book <- read.csv("../Raw Datasets/book_df.csv")
names(book)
head(book)

#delete variables not used in further analysis 
book <- book %>% select(id, book_publication_date, title, average_rating, ratings_count, text_reviews_count)

fwrite(book, "../Datasets/book_df.csv")
