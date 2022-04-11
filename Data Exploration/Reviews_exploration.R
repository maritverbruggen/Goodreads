library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

author <- read.csv("../../Datasets/author_df.csv")
book_info <- read.csv("../../Datasets/book_df_cleanPublisher.csv")
reviews_text <- read.csv("../../Datasets/reviews_thesis_text.csv")
ratings <- read.csv("../../Datasets/reviews_thesis_notext.csv")

#clean author en book information file 
author <- subset(author, select=-c(author_role,author_link, author_ratings_count, author_reviews_count))
book_info <- subset(publisher, select=c(id, book_publication_date, title,average_rating, num_pages, ratings_count, text_reviews_count))

#How many books have 1 author 
tabel <-  as.data.frame(table(author$book_id))
sum(tabel$Freq=="1")

#join author and book information file to "books" file 
books <- full_join(x=author,y=publisher,by=c("book_id"= "id"),all=TRUE)
View(books)



#time range for reviews in review file 
reviews_text$time <- as.Date(reviews_text$time)
min(reviews_text$time)
max(reviews_text$time)

#delete all rows earlier than 2007
reviews_text <- reviews_text[!(reviews_text$time <= "2007-01-01"),]

#time range for ratings in rating file 
ratings$time <- str_replace(ratings$time, ",","")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- as.Date(ratings$time, format="%b/%d/%Y")
min(ratings$time) 
max(ratings$time)

#delete all rows earlier than 2007 
ratings <- ratings[!(reviews_text$time <= "2007-01-01"),]



