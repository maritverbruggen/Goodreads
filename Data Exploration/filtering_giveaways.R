library(readr)
library(dplyr)
library(data.table)

giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
head(giveaways)

giveaways$giveaway_end_date <- as.Date(giveaways$giveaway_end_date)
giveaways$giveaway_start_date <- as.Date(giveaways$giveaway_start_date)
giveaways$days <- giveaways$giveaway_end_date - giveaways$giveaway_start_date

giveaways$days <- str_replace(giveaways$days, " days", "")
giveaways$days <- as.numeric(giveaways$days)

giveaways <- giveaways %>% filter(days >= 0)

fwrite(giveaways, "../Datasets/giveaways_thesiss.csv")
