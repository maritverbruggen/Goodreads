library(readr)
library(dplyr)

memory.limit()



reviews <- read.csv("../Raw Datasets/reviews_df.csv")
names(reviews)

reviews <- reviews %>% filter(reviews$text != "")

reviews <- reviews %>% filter(book_id %in% giveaways$book_id)

reviews$time <- as.Date(reviews$time)
sum(is.na(reviews$time))

reviews <- reviews %>% filter(time >= "2007-01-01")

#create variable that counts words in text 
reviews$word_count <- str_count(reviews$text, "\\w+")

#how many reviews only contain characters 
sum(reviews$word_count == 0)
reviews <- reviews[!(reviews$word_count==0),]
head(reviews)

fwrite(reviews, "../Datasets/reviews_df.csv")
