library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)
library(textcat)
library(tidytext)
library(janitor)
library(tibble)
library(tidyr)
library(stringr)
library(textstem)
library(reshape2)
library(data.table)


rm(list=ls())
memory.limit(size=1000000)

#read data 
reviews <- read.csv("../Estimation_samples/review_giveaway_df.csv")
books <- read.csv("../Datasets/book_df.csv")
books <- books %>% select(id,title)
reviews <- reviews %>% inner_join(books, by=(c("book_id" = "id")))

#remove reviews before 2015
reviews$time <- as.Date(reviews$time)
reviews <- reviews %>% filter(time >= "2015-01-01")

#remove variables not of interest
reviews <- reviews %>% select(book_id, title, ratings, time, text, giveaway_end_date, giveaway_after)

#remove books that received less than 5 reviews 
reviews_count <- reviews %>% 
  group_by(book_id) %>%
  count()
View(reviews_count)

reviews_filter <- reviews_count %>%
  filter(n >= 250)

reviews_filter <- reviews_filter %>%
  select(book_id)

reviews <- reviews %>%
  inner_join(reviews_filter, by="book_id")

table(reviews$giveaway_after)

#cut review text to make language detection faster 
reviews$text_cut <- substr(reviews$text, 1, 40)

reviews$book_id <- as.factor(reviews$book_id)

length(unique(reviews$book_id))

#cut review data set to make analyses faster 
reviews_cut <- reviews[1:50000,]
reviews_cut1 <- reviews[50001: 100000,]
reviews_cut2 <- reviews[100001: 150000,]
reviews_cut3 <- reviews[150001: 200000,]
reviews_cut4 <- reviews[200001: 250000,]
reviews_cut5 <- reviews[250001: 300000,]
reviews_cut6 <- reviews[300001: 350000,]
reviews_cut7 <- reviews[350001: 400000,]
reviews_cut8 <- reviews[400001: 450000,]
reviews_cut9 <- reviews[450001: 500000,]
reviews_cut10 <- reviews[500001: 550000,]
reviews_cut11 <- reviews[550001: 600000,]
reviews_cut12 <- reviews[600001: 620104,]

head(reviews_cut)

#check language of review text
reviews_cut$language <- textcat(reviews_cut$text_cut)
reviews_cut1$language <- textcat(reviews_cut1$text_cut)
reviews_cut2$language <- textcat(reviews_cut2$text_cut)
reviews_cut3$language <- textcat(reviews_cut3$text_cut)
reviews_cut4$language <- textcat(reviews_cut4$text_cut)
reviews_cut5$language <- textcat(reviews_cut5$text_cut)
reviews_cut6$language <- textcat(reviews_cut6$text_cut)
reviews_cut7$language <- textcat(reviews_cut7$text_cut)
reviews_cut8$language <- textcat(reviews_cut8$text_cut)
reviews_cut9$language <- textcat(reviews_cut9$text_cut)
reviews_cut10$language <- textcat(reviews_cut10$text_cut)
reviews_cut11$language <- textcat(reviews_cut11$text_cut)
reviews_cut12$language <- textcat(reviews_cut12$text_cut)


#filter for only english reviews 
reviews_cut <- reviews_cut %>% filter(language == "english")
reviews_cut1 <- reviews_cut1 %>% filter(language == "english")
reviews_cut2 <- reviews_cut2 %>% filter(language == "english")
reviews_cut3 <- reviews_cut3 %>% filter(language == "english")
reviews_cut4 <- reviews_cut4 %>% filter(language == "english")
reviews_cut5 <- reviews_cut5 %>% filter(language == "english")
reviews_cut6 <- reviews_cut6 %>% filter(language == "english")
reviews_cut7 <- reviews_cut7 %>% filter(language == "english")
reviews_cut8 <- reviews_cut8 %>% filter(language == "english")
reviews_cut9 <- reviews_cut9 %>% filter(language == "english")
reviews_cut10 <- reviews_cut10 %>% filter(language == "english")
reviews_cut11 <- reviews_cut11 %>% filter(language == "english")
reviews_cut12 <- reviews_cut12 %>% filter(language == "english")


reviews_en <- rbind(reviews_cut, 
                    reviews_cut1, 
                    reviews_cut2, 
                    reviews_cut3,
                    reviews_cut4,
                    reviews_cut5,
                    reviews_cut6,
                    reviews_cut7,
                    reviews_cut8,
                    reviews_cut9,
                    reviews_cut10,
                    reviews_cut11,
                    reviews_cut12)

fwrite(reviews_en, "../Estimation_samples/reviews_en.csv")




