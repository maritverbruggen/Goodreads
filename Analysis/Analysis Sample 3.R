library(readr)    
library(dplyr)    
library(tidyr)     
library(tidygraph) 
library(ggraph)
library(data.table)
library(plm)
library(fixest)

memory.limit(size=1000000)
rm(list=ls())

did <- read.csv("../Estimation_samples/est_3.csv")

did$time <- as.Date(did$time)

did$publication_date <- as.Date(did$publication_date)

did$ratings <- as.numeric(did$ratings)
did$days_since_publication <- as.numeric(did$days_since_publication)
did$post <- as.factor(did$post)
did$treated <- as.factor(did$treated)

did <- did %>% filter(time >= "2015-01-01")
names(did)
gravity_subfe = list()
all_FEs = c("focal_book_id", "month")
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(ratings ~ post * treated, did, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~focal_book_id)
