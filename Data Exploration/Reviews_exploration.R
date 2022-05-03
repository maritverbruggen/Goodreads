library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

rm(list=ls())
#time range for reviews in review file 
reviews <- read.csv("../Datasets/reviews_df.csv")

reviews$time <- as.Date(reviews$time)
min(reviews$time)
max(reviews$time)

unique_df <- unique(reviews$book_id)
length(unique_df)

#create variable that counts words in text 
reviews$word_count <- str_count(reviews$text, "\\w+")

#how many reviews only contain characters 
sum(reviews$word_count == "0")
reviews <- reviews[!(reviews$word_count==0),]

reviews <- reviews %>% filter(reviews$time >= "2015-01-01")

#descriptive statistics review length 
mean(reviews$word_count)
sd(reviews$word_count)
min(reviews$word_count)
max(reviews$word_count)

reviews$month <- format(reviews$time, "%m-%Y")
reviews_month <- reviews %>% group_by(month) %>% count()
mean(reviews_month$n)
sd(reviews_month$n)
min(reviews_month$n)
max(reviews_month$n)

View(reviews_month)
#group reviews per month 


ggplot(reviews, aes(x=lubridate::floor_date(time, "month"))) +
  geom_bar()+ 
  xlab("Review Date grouped by Month") + 
  ylab("Number of Reviews") + 
    




#create review counter 
reviews$review_counter <- 1
View(reviews)
reviews_month <- reviews %>% 
  group_by(month = lubridate::floor_date(time, "month")) %>%
  summarize(summary_variable = sum(review_counter))
View(reviews_month)

#plot reviews per month
ggplot(reviews_month, aes(x=month, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2015-01-01','2021-05-01'))) + 
  ylab("Amount of Reviews per Month") + xlab("Year")

#plot ratings and reviews in one graph 
ggplot(reviews_month, aes(x=month, y=summary_variable, color="red")) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2015-01-01','2021-04-01'))) + 
  ylab("Amount of Reviews per Month") + xlab("Year") +
  geom_line(data = ratings_month, aes(x = month, y = summary_variable), color = "blue")


reviews_month <- reviews_month[2:172,]
mean(reviews_month$summary_variable)
sd(reviews_month$summary_variable)
min(reviews_month$summary_variable)
max(reviews_month$summary_variable)
