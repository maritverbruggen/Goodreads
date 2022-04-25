library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(fixest)
library(pdftools)
install.packages("IGM.MEA")
library(igm.mea)

rm(list=ls())
memory.limit(size=1000000)
memory.limit()

#read data 
graph_data <- read.csv("../Estimation_samples/est_3_1.csv")

#remove data before 2015 
graph_data$time <- as.Date(graph_data$time)
graph_data_filter <- graph_data %>% filter(graph_data$time >= "2016-01-01")

#factor dummy variables
graph_data_filter$treated <- as.factor(graph_data_filter$treated)

#create variable days since giveaway 
graph_data_filter$giveaway_end_date <- as.Date(graph_data_filter$giveaway_end_date)
graph_data_filter$days_since_giveaway <- graph_data_filter$time - graph_data_filter$giveaway_end_date

#check columns 
names(graph_data)

graph_data_filter$days_since_giveaway <- str_replace(graph_data_filter$days_since_giveaway, " days", "")
graph_data_filter$days_since_giveaway <- as.numeric(graph_data_filter$days_since_giveaway)

graph_data_filter_days <- graph_data_filter %>% filter(days_since_giveaway >= -360 & days_since_giveaway <= 360)
max(graph_data_filter_days$days_since_giveaway)

graph_data_filter_days$days_since_gw_bin <- cut_interval(graph_data_filter_days$days_since_giveaway,length=30)

graph_data_filter_days$ratings <- as.numeric(graph_data_filter_days$ratings)
graph_data_filter_days$treated <- as.factor(graph_data_filter_days$treated)
graph_data_filter_days$treated <- ifelse(graph_data_filter_days$treated == "0", "No", "Yes")

table(graph_data_filter_days$treated)

graph_data_plot <- graph_data_filter_days %>% group_by(treated, days_since_gw_bin) %>% summarise(mean = mean(ratings))
View(graph_data_plot)
  
pdf(file = "../Plots/Starrating.pdf")
  
ggplot(data=graph_data_plot, aes(x=days_since_gw_bin, y=mean, group=treated, colour=treated))+
  geom_line() + 
  geom_vline(xintercept = "(0,30]", 
             color = "blue") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(hjust=1, angle=90),
        plot.title = element_text(hjust = 0.5)) +
  xlab("Days Since End of Giveaway") +
  ylab("Average Star Rating") + 
  ggtitle("Average Star Rating per 30-days over Time") + 
  labs(color="Giveaway Book?")
dev.off()

#read panel regression data 
rm(list=ls())
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")

#remove data before 2015 
ra_gw$time <- as.Date(ra_gw$time) 
ra_gw_filter <- ra_gw %>% filter(time >= "2016-01-01")

#create variable days since giveaway 
ra_gw_filter$giveaway_end_date <- as.Date(ra_gw_filter$giveaway_end_date)
ra_gw_filter$days_since_giveaway <- ra_gw_filter$time - ra_gw_filter$giveaway_end_date

ra_gw_filter$days_since_giveaway <- str_replace(ra_gw_filter$days_since_giveaway, " days", "")
ra_gw_filter$days_since_giveaway <- as.numeric(ra_gw_filter$days_since_giveaway)

ra_gw_days <- ra_gw_filter %>% filter(days_since_giveaway >= -360 & days_since_giveaway <= 360)

ra_gw_days$days_since_gw_bin <- cut_interval(ra_gw_days$days_since_giveaway,length=30)

ra_gw_days$ratings <- as.numeric(ra_gw_days$ratings)

ra_gw_graph <- ra_gw_days %>% group_by(days_since_gw_bin) %>% summarise(mean = mean(ratings))

ggplot(data=ra_gw_graph, aes(x=days_since_gw_bin, y=mean, group=1))+
  geom_line() + 
  geom_vline(xintercept = "(0,30]", 
             color = "blue") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(hjust=1, angle=90),
        plot.title = element_text(hjust = 0.5)) +
  xlab("Days Since End of Giveaway") +
  ylab("Average Star Rating") + 
  ggtitle("Average Star Rating per 30-days for Giveaway Books")

dev.off()