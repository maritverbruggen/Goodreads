#import packages 
library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

View(ratings)
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")

#check whether NAs included 
sum(is.na(ratings$ratings))
sum(is.na(ratings$book_id))
sum(is.na(ratings$review_id))
sum(is.na(ratings$new_review_id))

#distribution of ratings
table(ratings$ratings)

#min and max rating
min(ratings$ratings)
max(ratings$ratings)

#transform time variable 
ratings$time <- str_replace(ratings$time, ",","")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- as.Date(ratings$time, format="%b/%d/%Y")

#show min and max time 
min(ratings$time)
max(ratings$time)

#remove ratings before 2007 
sum(ratings$time < as.Date("2007-01-01"))
ratings <- ratings[order(ratings$time),]
ratings <- subset(ratings, time >= as.Date("2007-01-01"))


#plot distribution of ratings
ggplot(ratings, aes(x = ratings)) +
  geom_bar() + 
  xlab("Rating Score") + ylab("Number of Ratings") +
  geom_text(stat="count", aes(label=..count..), vjust=0) +
  geom_text(stat="count", aes(label = scales::percent((..count..)/sum(..count..))),
            color="white", vjust=5)+ 
  theme_minimal()


#average rating over time 
mean(ratings$ratings)
sd(ratings$ratings)

mean(ratings$time)
sd(ratings$time)

#cumulative amount of ratings over time 

#create new column to be able to perform cumsum for amount of ratings
ratings$ratings_counter <- ifelse(is.na(ratings$ratings)==FALSE, 1, 0)
View(ratings)

#put ratings in order of time 
ratings <- ratings[order(ratings$time),]

#create cumsum variable that adds ratings
ratings$cumsum <- cumsum(ratings$ratings_counter)
View(ratings)
ggplot(ratings, aes(x=time, y=(cumsum))) + geom_line()

#Calculate and Visualize amount of Ratings per Month 
ratings$ratings_counter <- as.numeric(ratings$ratings_counter)
ratings_month <- ratings %>% 
  group_by(month = lubridate::floor_date(time, "month")) %>%
  summarize(summary_variable = sum(ratings_counter))
ratings_month$cumsum <- cumsum(ratings_month$summary_variable)

ggplot(ratings_month, aes(x=month, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2015-01-01','2021-04-01'))) + 
  ylab("Amount of Ratings per Month") + xlab("Year")


View(ratings_month)
min(ratings_month$summary_variable[2:172])
max(ratings_month$summary_variable)
sd(ratings_month$summary_variable[2:172])
mean(ratings_month$summary_variable[2:172])



