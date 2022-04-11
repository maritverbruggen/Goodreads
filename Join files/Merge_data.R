library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

rm(list=ls())
#how many books that are in giveaway data set are also in ratings data set? 
giveaways$book_id2 <- giveaways$book_id
ct_gw_ra <- giveaways %>% inner_join(ratings, by = "book_id")
df_uniq <- unique(ct_gw_ra$book_id2)
length(df_uniq)


#merge author and book info file
books <- book_info %>% inner_join(author, by=c("id"="book_id"))
df_uniq <- unique(books$id)
length(df_uniq)

#delete duplicate rows for books with multiple authors
books <- books[!duplicated(books$id), ]

#merge rating and review file 
rating_review <- ratings %>% left_join(reviews, by="new_review_id")
View(rating_review)

#clean rating and review file 
rating_review <- subset(rating_review, select = c(book_id.x, new_review_id, ratings.x, time.x, text))

#change time variable
rating_review$time.x <- str_replace(rating_review$time.x, ",","")
rating_review$time.x <- str_replace(rating_review$time.x, " ", "/")
rating_review$time.x <- str_replace(rating_review$time.x, " ", "/")
rating_review$time.x <- as.Date(rating_review$time.x, format="%b/%d/%Y")

#delete all rows earlier than 2007 
rating_review <- rating_review[!(rating_review$time <= "2007-01-01"),]

#rename first book id column
names(rating_review)[1] <- 'book_id'

#merge books and giveaways file 
books_giveaways <- books %>% full_join(giveaways, by=c("id"="book_id"))

#create dummy variable for participation in giveaway
for (i in seq(1,length(books_giveaways$id))){
  if (is.na(books_giveaways$giveaway_id[i])==TRUE){
    books_giveaways$giveaway_dummy[i] <- "0"
  }else{
    books_giveaways$giveaway_dummy[i] <- "1"
  }
}

#join reviews and books_giveaways datasets
full_data <- rating_review %>% left_join(books_giveaways, by=(c("book_id"="id")))
View(full_data)
