library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)

#time range for reviews in review file 
reviews$time <- as.Date(reviews$time)
min(reviews$time)
max(reviews$time)

#delete all rows earlier than 2007
reviews_text <- reviews_text[!(reviews_text$time <= "2007-01-01"),]

#time range for ratings in rating file 
ratings$time <- str_replace(ratings$time, ",","")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- str_replace(ratings$time, " ", "/")
ratings$time <- as.Date(ratings$time, format="%b/%d/%Y")
min(ratings$time) 
max(ratings$time)

#delete all rows earlier than 2007 
ratings <- ratings[!(reviews_text$time <= "2007-01-01"),]



