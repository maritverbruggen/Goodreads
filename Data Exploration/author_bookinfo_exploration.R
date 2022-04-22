library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

author <- read.csv("../Datasets/author_df.csv")
book_info <- read.csv("../Datasets/book_df.csv")
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")

#remove duplicate row from book information file 
book_info <-book_info[!duplicated(book_info$id), ] 

#how many unique books in book_info file 
amount_books <- unique(author$book_id)
length(amount_books)

#how many unique books in author file 
amount_books_author <- unique(author$book_id)
length(amount_books_author)

#how many unique authors in author file 
df_uniq <- unique(author$author_id)
length(df_uniq)

#How many giveaway books have authors written 
tabel <-  as.data.frame(table(author$author_name)) 
tabel <- tabel %>% arrange(Freq) 
View(tabel)

#How many books have multiple authors 
tabel <-  as.data.frame(table(author$book_id)) 
tabel <- tabel %>% arrange(Freq) 

tabel <- tabel %>% group_by(Freq) %>% count()

#check variables in dataset 
names(book_info)
