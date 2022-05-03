library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(fixest)
library(pdftools)
library(igm.mea)

rm(list=ls())
memory.limit(size=1000000)
memory.limit()

#read data 
graph_data <- read.csv("../Estimation_samples/review_giveaway_df.csv")

#remove data before 2015 
graph_data$time <- as.Date(graph_data$time)
graph_data_filter <- graph_data %>% filter(graph_data$time >= "2015-01-01")

#create variable days since giveaway 
graph_data_filter$giveaway_end_date <- as.Date(graph_data_filter$giveaway_end_date)
graph_data_filter$days_since_giveaway <- graph_data_filter$time - graph_data_filter$giveaway_end_date

graph_data_filter$days_since_giveaway <- str_replace(graph_data_filter$days_since_giveaway, " days", "")
graph_data_filter$days_since_giveaway <- as.numeric(graph_data_filter$days_since_giveaway)

graph_data_filter_days <- graph_data_filter %>% filter(days_since_giveaway >= -360 & days_since_giveaway <= 360)

graph_data_filter_days$days_since_gw_bin <- cut_interval(graph_data_filter_days$days_since_giveaway,length=30)

graph_data_filter_days$word_count <- str_count(graph_data_filter_days$text, "\\w+")

graph_data_plot <- graph_data_filter_days %>% group_by(days_since_gw_bin) %>% summarise(mean = mean(word_count))
View(graph_data_plot)

ggplot(data=graph_data_plot, aes(x=days_since_gw_bin, y=mean, group=1))+
    geom_line() + 
    geom_vline(xintercept = "(-30,0]", 
               color = "blue") +
    theme(text = element_text(size=10),
          axis.text.x = element_text(hjust=1, angle=90),
          plot.title = element_text(hjust = 0.5)) +
    ylim(0,200) +
    xlab("Days Since End of Giveaway") +
    ylab("Average Review Length") + 
    ggtitle("Average Review Length per 30-days for Giveaway Books")

View(graph_data_plot)
