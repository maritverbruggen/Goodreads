library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

author <- read.csv("../../Datasets/author_df.csv")
book_info <- read.csv("../../Datasets/book_df_cleanPublisher.csv")
View(author)
View(book_info)
#how many unique books in book_info file 
amount_books <- unique(book_info$id)
length(df_uniq)

#how many unique books in author file 
amount_books_author <- unique(author$book_id)
length(amount_books_author)
#how many unique authors in author file 
df_uniq <- unique(author$author_id)
length(df_uniq)
#How many books have 1 author 
tabel <-  as.data.frame(table(author$book_id))
sum(tabel$Freq=="1")
