library(haven)

rm(list=ls())

book_info <- read.csv("../Datasets/book_df_cleanPublisher.csv")
author <- read.csv("../Datasets/author_df.csv")
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
reviews <- read.csv("../Datasets/reviews_thesis_text.csv")
similar_map <- read.csv("../Datasets/similar_map_thesis.csv")
similar_meta <- read.csv("../Datasets/similar_meta_thesis.csv")

View(giveaways)
View(similar_map)
View(similar_meta)
