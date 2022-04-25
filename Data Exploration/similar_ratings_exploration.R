library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(tidyverse)
library(data.table)

rm(list=ls())

memory.limit()
memory.limit(size=1000000)
memory.limit()

sim_rat <- read.csv("../Datasets/similar_ratings_df.csv")

#reformat time variable 
sim_rat$time <- as.Date(sim_rat$time)
min(sim_rat$time)
max(sim_rat$time)

sim_rat <- sim_rat %>% select(focal_book_id, similar_book_id, title, new_review_id, ratings, time)
head(sim_rat)

fwrite(sim_rat, "../Datasets/similar_ratings_df.csv")
