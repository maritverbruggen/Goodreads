library(readr)
library(dplyr)
library(data.table)
library(Rmisc)

similar_ratings <- fread("../Datasets/oud/similar_review.csv")
head(similar_ratings)

similar_ratings <- similar_ratings %>% select(similar_book_id, new_review_id, ratings, time, focal_book_id, title)
similar_meta <- read.csv("../Raw Datasets/similar_meta_df.csv")

similar_ratings <- similar_ratings %>% filter(similar_book_id %in% similar_meta$similar_book_id)
similar_ratings$time <- as.Date(similar_ratings$time)
min(similar_ratings$time)
max(similar_ratings$time)

sum(similar_ratings$time < "2007-01-01")
similar_ratings <- similar_ratings %>% filter(time >= "2007-01-01")
df_uniq <- unique(similar_ratings$similar_book_id)
length(df_uniq)

fwrite(similar_ratings, "../Datasets/similar_ratings_df.csv")
