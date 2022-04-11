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
tabel[1]
tabel[1] / (tabel[1]+tabel[2]+tabel[3]+tabel[4]+tabel[5])

#how many unique focal books 
df_uniq <- unique(similar_map$similar_book_id)
length(df_uniq)

df_uniq <- unique(similar_meta$similar_book_id)
length(df_uniq)
