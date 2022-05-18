library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(fixest)

rm(list=ls())
memory.limit(size=1000000)
memory.limit()

#read data 
re_gw <- read.csv("../Estimation_samples/review_giveaway_df.csv")

re_gw$time <- as.Date(re_gw$time)
re_gw <- re_gw %>% filter(time >= "2015-01-01")
re_gw$giveaway_end_date <- as.Date(re_gw$giveaway_end_date)

#create days_since_gw variable
re_gw$days_since_gw <- re_gw$time - re_gw$giveaway_end_date
re_gw$days_since_gw <- str_replace(re_gw$days_since_gw, " days", "")
re_gw$days_since_gw <- as.numeric(re_gw$days_since_gw)

#filter for one day before end date to one year after end date 
re_gw_days <- re_gw %>% filter(days_since_gw >= -360 & days_since_gw <= 360)

#assign each row to a bin, 30 days interval
re_gw_days$bins <- cut_interval(re_gw_days$days_since_gw,length=30)

#create new dataset for graph 
re_gw_graph <- re_gw_days %>% group_by(bins) %>% count()

pdf(file = "../Plots/#Reviews.pdf")
plot1 <- ggplot(data=re_gw_graph, aes(x=bins, y=n, group=1))+
    geom_line() + 
    geom_vline(xintercept = "(-30,0]", 
               color = "blue") +
    geom_vline(xintercept = "(0,30]", 
             color = "blue") +
    theme(text = element_text(size=10),
          axis.text.x = element_text(hjust=1, angle=90),
          plot.title = element_text(hjust = 0.5)) +
    xlab("Days Since End of Giveaway") +
    ylab("Number of Reviews") + 
    ggtitle("Number of Reviews per 30-days over time")
dev.off()

print(plot1)
