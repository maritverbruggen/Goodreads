library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(fixest)
library(pdftools)

rm(list=ls())
memory.limit(size=1000000)
memory.limit()

#read data 
re_gw <- read.csv("../Estimation_samples/review_giveaway_df.csv")

re_gw$time <- as.Date(re_gw$time)
re_gw <- re_gw %>% filter(time >= "2015-01-01")

re_gw$giveaway_end_date <- as.Date(re_gw$giveaway_end_date)
re_gw$days_since_gw <- re_gw$time - re_gw$giveaway_end_date
re_gw$days_since_gw <- str_replace(re_gw$days_since_gw, " days", "")
re_gw$days_since_gw <- as.numeric(re_gw$days_since_gw)

re_gw_days <- re_gw %>% filter(days_since_gw >= -360 & days_since_gw <= 360)
re_gw_days$bins <- cut_interval(re_gw_days$days_since_gw,length=30)

re_gw_graph <- re_gw_days %>% group_by(bins) %>% count()

ggplot(data=re_gw_graph, aes(x=bins, y=n, group=1))+
    geom_line() + 
    geom_vline(xintercept = "(-30,0]", 
               color = "blue") +
    theme(text = element_text(size=10),
          axis.text.x = element_text(hjust=1, angle=90),
          plot.title = element_text(hjust = 0.5)) +
    xlab("Days Since End of Giveaway") +
    ylab("Number of Reviews") + 
    ggtitle("Number of Reviews per 30-days over time")
