#import packages 
library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

rm(list=ls())
memory.limit(size=1000000)

ratings <- read.csv("../Datasets/ratings_df.csv")

#check whether NAs included 
sum(is.na(ratings$ratings))
sum(is.na(ratings$book_id))
sum(is.na(ratings$review_id))
sum(is.na(ratings$new_review_id))

#distribution of ratings
tabel <- table(ratings$ratings)
total <- tabel[1] + tabel[2] + tabel[3] + tabel[4] + tabel[5]
tabel[5]/total*100

#min and max rating
min(ratings$ratings)
max(ratings$ratings)
mean(ratings$ratings)
sd(ratings$ratings)

#show min and max time 
ratings$time <- as.Date(ratings$time)
min(ratings$time)
max(ratings$time)

ratings$month <- format(ratings$time, "%m-%Y")

ratings_group <- ratings %>% group_by(month) %>% count()
View(ratings_group)
ratings_group <- ratings_group %>% filter(month != "05-2021")
mean(ratings_group$n)
sd(ratings_group$n)
min(ratings_group$n)
max(ratings_group$n)

ratings_filter <- ratings %>% filter(time >= '2015-01-01')

#amount of ratings per month over time 
ggplot(ratings_filter, aes(x=lubridate::floor_date(time, "month"))) +
  geom_bar()+ 
  xlab("Rating Date grouped by Month") + 
  ylab("Number of Ratings")

geom_hline(yintercept = 814.2857,color="red")


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

View(ratings_month)

