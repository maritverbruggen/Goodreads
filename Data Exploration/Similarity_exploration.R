library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

similar_map <- read.csv("../Datasets/similar_map_thesis.csv")
similar_meta <- read.csv("../Datasets/similar_meta_thesis.csv")
View(similar_map)
View(similar_meta)

#how many books are matched to a focal book 
tabel <- as.data.frame(table(similar_map$focal_book_id))
View(tabel)
tabel <- table(tabel$Freq)
View(tabel)
tabel[1]
tabel[1] / (tabel[1]+tabel[2]+tabel[3]+tabel[4]+tabel[5])

#how many unique focal books 
df_uniq <- unique(similar_map$similar_book_id)
length(df_uniq)

df_uniq <- unique(similar_meta$similar_book_id)
length(df_uniq)
View(similar_map)
View(similar_meta)

#check whether NAs inserted
sum(is.na(similar_meta))
sum(is.na(similar_meta$publication_year))

#descriptive statistics
mean(similar_meta$rating)
sd(similar_meta$rating)
min(similar_meta$rating)
max(similar_meta$rating)

mean(similar_meta$reviews)
sd(similar_meta$reviews)
min(similar_meta$reviews)
max(similar_meta$reviews)

mean(similar_meta$average.rating)
sd(similar_meta$average.rating)
min(similar_meta$average.rating)
max(similar_meta$average.rating)
