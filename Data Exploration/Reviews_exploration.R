library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

#time range for reviews in review file 
reviews$time <- as.Date(reviews$time)
min(reviews$time)
max(reviews$time)

#delete all rows earlier than 2007
reviews <- reviews[!(reviews$time <= "2007-01-01"),]

#delete all reviews without text 
reviews <- reviews[!(reviews$text == ""),]
View(reviews)

#create variable that counts words in text 
reviews$word_count <- str_count(reviews$text, "\\w+")

#how many reviews only contain characters 
sum(reviews$word_count == 0)
reviews <- reviews[!(reviews$word_count==0),]

#descriptive statistics review length 
mean(reviews$word_count)
sd(reviews$word_count)
min(reviews$word_count)
max(reviews$word_count)

#group reviews per month 
