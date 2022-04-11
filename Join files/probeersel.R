library(haven)
library(tidyverse)
library(dplyr)
library(scales)

giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")

book_info <- read.csv("../Datasets/book_df_cleanPublisher.csv")
book_info <- subset(book_info, select=c(id, average_rating))

book_gw <- book_info %>% left_join(giveaways, by=c("id"="book_id"))
View(book_gw)

for (i in seq(1,length(book_gw$id))){
  if (is.na(book_gw$book_id2[i])==TRUE){
    book_gw$gw_dummy[i] <- "0"
  }else{
    book_gw$gw_dummy[i] <- "1"
  }
}

#calculate average rating of books that have or have not been on giveaway 
mean_rating_gw <- mean(book_gw$average_rating[book_gw$gw_dummy==1])
mean_rating_no <- mean(book_gw$average_rating[book_gw$gw_dummy==0])
mean_rating <- mean(book_gw$average_rating)

#calculate average rating of authors that have or have not been performing a giveaway 
authors <- read.csv("../Datasets/author_df.csv")
View(authors)
authors <- subset(authors, select=c("book_id", "author_average_rating"))
author_gw <- authors %>% left_join(giveaways, by="book_id")
for (i in seq(1,length(author_gw$book_id))){
  if (is.na(author_gw$book_id2[i])==TRUE){
    author_gw$gw_dummy[i] <- "0"
  }else{
    author_gw$gw_dummy[i] <- "1"
  }
}

#average rating for authors that have or have not performed a giveaway 
mean_rating_au_gw <- mean(author_gw$author_average_rating[author_gw$gw_dummy==1])
mean_rating_au_no <- mean(author_gw$author_average_rating[author_gw$gw_dummy==0])
mean_rating_au <- mean(author_gw$author_average_rating)

#average rating for well-known authors or not well-known authors 
table(author$author_ratings_count)
min(author$author_ratings_count)
max(author$author_ratings_count)
median(author$author_ratings_count)

mean(authors$author_average_rating[authors$author_ratings_count>=535])
mean(authors$author_average_rating[authors$author_ratings_count<=535])
mean(authors$author_average_rating[authors$author_ratings_count>=500000])

ggplot(authors, aes(x=ct_rating, y=author_average_rating)) +
  geom_line() +
  scale_x_log10()
authors$author_ratings_count <- as.numeric(authors$author_ratings_count)
authors$author_ratings_count <- authors$author_ratings_count/100
authors$author_ratings_count <- round(authors$author_ratings_count, digits=0)

authors<-authors[!(authors$author_ratings_count<=0),]
View(authors)

authors$ct_rating <- round(authors$author_ratings_count/100)
authors$ct_rating <- authors$ct_rating/100
