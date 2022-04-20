library(readr)    
library(dplyr)    
library(tidyr)     
library(tidygraph) 
library(ggraph)

rm(similar_map)

did <- read.csv("../Estimation_samples/similar_book_ratings.csv")
did <- did %>% arrange(focal_book_id)
View(did)

#correct time variable of review time 
did$time <- as.Date(did$time, "%Y-%m-%d")

#correct time variable for giveaway end date 
did$giveaway_end_date <- as.Date(did$giveaway_end_date, "%Y-%m-%d")

#add dummy for pre and post treatment group 
did$post <- ifelse(did$time > did$giveaway_end_date, 1, 0)


View(did)
