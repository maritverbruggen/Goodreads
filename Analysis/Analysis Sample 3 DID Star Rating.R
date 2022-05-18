library(readr)    
library(dplyr)    
library(tidyr)     
library(data.table)
library(fixest)
library(stringr)
library(gridExtra)


memory.limit(size=1000000)
rm(list=ls())

did <- read.csv("../Estimation_samples/est_3.csv")

did$time <- as.Date(did$time)
did <- did %>% filter(time >= "2015-01-01")

#amount of observations per group
groups <- did %>% group_by(treated, post) %>% count()
View(groups)

#change month variable 
did$month <- format(did$time, "%Y-%m")
did_treat <- did %>% filter(treated == "1")
did_non <- did %>% filter(treated == "0")

length(unique(did_treat$similar_book_id))
length(unique(did_non$similar_book_id))

#descriptive statistics giveaway books
mean(did_treat$ratings)
sd(did_treat$ratings)

mean(did_non$ratings)
sd(did_non$ratings)

#group by month 

did_month_treat <- did_treat %>% group_by(month) %>% count()
did_month_non <- did_non %>% group_by(month) %>% count()

did_month_treat <- did_month_treat[1:76,]
mean(did_month_treat$n)
sd(did_month_treat$n)
min(did_month_treat$n)
max(did_month_treat$n)

View(did_month_non)
mean(did_month_non$n)
sd(did_month_non$n)
min(did_month_non$n)
max(did_month_non$n)
sum(did_month_non$n)



did$post <- as.factor(did$post)
did$treated <- as.factor(did$treated)
did$focal_book_id <- as.factor(did$focal_book_id)
did$month <- as.factor(did$month)

m2 <- feols(ratings ~ post * treated | focal_book_id + month, did)
etable(m2)

tab_model(m1,
          m2, 
          show.ci = FALSE, 
          dv.labels = c("Fixed Effects Regression", "Diff-in-Diff"),
          pred.labels = c("Post Giveaway", "Giveaway Effect", "Interaction Effect"),
          title = "Effect of Giveaways on Star Rating", 
          show.intercept = TRUE)

?tab_model