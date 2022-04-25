library(readr)
library(dplyr)

rm(list=ls())
memory.limit(size=1000000)

giveaways <- read.csv("../Raw Datasets/giveaways_df.csv")

names(giveaways)
giveaways <- giveaways %>% select(giveaway_id, book_id, book_title, release_date, copy_n, request_n, giveaway_start_date, giveaway_end_date, listedby_book_n, listedby_friend_n)
View(giveaways)

giveaways$giveaway_end_date <- as.Date(giveaways$giveaway_end_date)
giveaways$giveaway_start_date <- as.Date(giveaways$giveaway_start_date)
giveaways$gw_duration <- giveaways$giveaway_end_date - giveaways$giveaway_start_date
giveaways$gw_duration <- str_replace(giveaways$gw_duration, " days", "")
giveaways$gw_duration <- as.numeric(giveaways$gw_duration)

giveaways <- giveaways %>% filter(gw_duration > 0)

giveaways$release_date <- str_replace(giveaways$release_date, ",", "")
giveaways$release_date <- str_replace_all(giveaways$release_date, " ", "-")

giveaways$release_date <- as.Date(giveaways$release_date, "%b-%d-%Y")

fwrite(giveaways, "../Datasets/giveaways_df.csv")
