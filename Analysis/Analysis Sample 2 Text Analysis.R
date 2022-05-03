library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)
library(textcat)
library(tidytext)
library(janitor)
library(tibble)
library(tidyr)
library(stringr)
library(textstem)
library(reshape2)
library(data.table)
library(textdata)
library(fixest)


rm(list=ls())
memory.limit(size=1000000)

#read data 
df <- read.csv("../Estimation_samples/reviews_en.csv")

#unnest tokens 
review_token <- 
  df %>%
  rownames_to_column("review_id") %>%
  unnest_tokens(word, text)

#remove stop words 
data(stop_words)

df_no_stop <- review_token %>% 
  anti_join(stop_words)

#add afinn number to words
get_sentiments("afinn")

sm_level <- df_no_stop %>% 
  inner_join(get_sentiments("afinn"))
View(sm_level)

sm_values <- sm_level %>% 
  group_by(review_id, book_id, giveaway_after, time, ratings) %>% 
  summarise(value = sum(value))

head(sm_values)

sm_values$value <- as.numeric(sm_values$value)
sm_values$time <- as.Date(sm_values$time)
sm_values$month <- format(sm_values$time, "%Y-%m")

gravity_subfe = list()
all_FEs = c("book_id", "month")

lm1 <- feols(value ~ ratings | book_id + month, sm_values)
etable(lm1)
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(value ~ giveaway_after, sm_values, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~book_id)


