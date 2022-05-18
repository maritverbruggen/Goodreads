library(readr)    
library(dplyr)    
library(tidyr)     
library(tidygraph) 
library(ggraph)
library(data.table)
library(plm)
library(fixest)
library(stringr)

rm(list=ls())
memory.limit(size=1000000)

#read data, estimation sample 3 
did <- read.csv("../Estimation_samples/est_3.csv")

#transform time variable to correct structure 
did$time <- as.Date(did$time)
did$giveaway_end_date <- as.Date(did$giveaway_end_date)
did <- did %>% filter(time >= "2015-01-01")

did$month <- format(did$time, "%Y-%m")
did$gw_month <- format(did$giveaway_end_date, "%Y-%m")

did_count <- did %>% count(focal_book_id, month, gw_month, treated, post)
View(did_count)

did_count$post <- ifelse(did_count$month > ratings_count$gw_month, "1", "0")
did_count$post <- as.factor(did_count$post)

m2 <- feols(n~ post * treated | focal_book_id + month, did_count)


tab_model(m1,
          m2, 
          show.ci = FALSE, 
          dv.labels = c("Fixed Effects Regression", "Diff-in-Diff"),
          pred.labels = c("Post Giveaway", "Giveaway Effect", "Interaction Effect"),
          title = "Effect of Giveaways on Number of Ratings", 
          show.intercept = TRUE)
