library(haven)
library(plm)
library(readr)
library(tidyverse)
library(ggplot2)
library(SciViews)
library(sjmisc)
library(fixest)

#read data 
rm(list=ls())
memory.limit(size=1000000)
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")


#remove data before 2015 
ra_gw$time <- as.Date(ra_gw$time) 
ra_gw <- ra_gw %>% filter(time >= "2015-01-01")
#create month variable 
ra_gw$month <- format(ra_gw$time, "%Y-%m")


sum(ra_gw$giveaway_after == "1")
sum(ra_gw$giveaway_after == "0")

ra_gw_pre <- ra_gw %>% filter(giveaway_after == "0")
ra_gw_post <- ra_gw %>% filter(giveaway_after == "1")

#descriptive statistics average rating
mean(ra_gw_pre$ratings)
sd(ra_gw_pre$ratings)
min(ra_gw_pre$ratings)
max(ra_gw_pre$ratings)

mean(ra_gw_post$ratings)
sd(ra_gw_post$ratings)
min(ra_gw_post$ratings)
max(ra_gw_post$ratings)

#group by month 
ra_month_pre <- ra_gw_pre %>% group_by(month) %>% count()
ra_month_pre <- ra_month_pre[1:70,]

ra_month_post <- ra_gw_post %>% group_by(month) %>% count()
ra_month_post <- ra_month_post[1:40,]

#descriptive statistics for amount of ratings per month
mean(ra_month_pre$n)
sd(ra_month_pre$n)
min(ra_month_pre$n)
max(ra_month_pre$n)

mean(ra_month_post$n)
sd(ra_month_post$n)
min(ra_month_post$n)
max(ra_month_post$n)

names(ra_gw)
#create variable days since giveaway 
ra_gw$giveaway_end_date <- as.Date(ra_gw$giveaway_end_date)
ra_gw$days_since_giveaway <- ra_gw$time - ra_gw$giveaway_end_date

ra_gw$days_since_giveaway <- str_replace(ra_gw$days_since_giveaway, " days", "")
ra_gw$days_since_giveaway <- as.numeric(ra_gw$days_since_giveaway)

ra_gw_days <- ra_gw %>% filter(days_since_giveaway >= -360 & days_since_giveaway <= 360)

ra_gw_days$days_since_gw_bin <- cut_interval(ra_gw_days$days_since_giveaway,length=30)

ra_gw_days$ratings <- as.numeric(ra_gw_days$ratings)

ra_gw_graph <- ra_gw_days %>% group_by(days_since_gw_bin) %>% summarise(mean = mean(ratings))

ggplot(data=ra_gw_graph, aes(x=days_since_gw_bin, y=mean, group=1))+
    geom_line() + 
    geom_vline(xintercept = "(-30,0]", 
               color = "blue") +
    theme(text = element_text(size=10),
          axis.text.x = element_text(hjust=1, angle=90),
          plot.title = element_text(hjust = 0.5)) +
    xlab("Days Since End of Giveaway") +
    ylab("Average Star Rating") + 
    ggtitle("Average Star Rating per 30-days for Giveaway Books") +
    ylim(3,4)



ra_gw$ratings <- as.numeric(ra_gw$ratings)
ra_gw$book_id <- as.factor(ra_gw$book_id)

#fixed effect analysis on sample 
gravity_subfe = list()
all_FEs = c("book_id", "month")
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(ratings ~ giveaway_after, ra_gw, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~book_id)



