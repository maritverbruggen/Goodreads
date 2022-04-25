library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

author <- read.csv("../Raw Datasets/author_df.csv")

author <- author %>% filter(book_id %in% book_info$id)
df_uniq <- unique(author$author_id)
length(df_uniq)

author_amount <- author %>% group_by(author_name) %>% count()
View(author_amount)

book_amount <- author %>% group_by(book_id) %>% count()
View(book_amount)
sum(book_amount$n == 1)

#check variables in dataset 
names(book_info)
