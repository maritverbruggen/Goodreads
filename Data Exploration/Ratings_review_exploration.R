library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

reviews <- read.csv("../Datasets/reviews_thesis_text.csv")
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
View(reviews)
View(ratings)
#time range for reviews in review file 
reviews$time <- as.Date(reviews$time)
min(reviews$time)
max(reviews$time)

#delete all rows earlier than 2007
reviews <- reviews[!(reviews$time <= "2007-01-01"),]

#time range for ratings in rating file 
ratings$time <- str_replace(ratings$time, ",","")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- as.Date(ratings$time, format="%b/%d/%Y")
min(ratings$time) 
max(ratings$time)

#delete all rows earlier than 2007 
ratings <- ratings[!(ratings$time <= "2007-01-01"),]

#how many rating + review
rating_review <- ratings %>% inner_join(reviews, by="new_review_id")

#how many rating only
11741565 - sum(rating_review$text != "")

#how many review only 
sum(rating_review$text != "")


