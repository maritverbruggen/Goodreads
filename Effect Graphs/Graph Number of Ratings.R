library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(fixest)
library(pdftools)


#remove stored files and increase memory limit 
rm(list=ls())
memory.limit(size=1000000)


#read data for first plot, estimation sample 1 
ra_gw <- read.csv("../Estimation_samples/rating_giveaway_df.csv")

#transform time variables to correct structure 
ra_gw$time <- as.Date(ra_gw$time)
ra_gw_filter <- ra_gw %>% filter(time >= "2015-01-01")
ra_gw_filter$giveaway_end_date <- as.Date(ra_gw_filter$giveaway_end_date)

#create days since gw variable 
ra_gw_filter$days_since_gw <- ra_gw_filter$time - ra_gw_filter$giveaway_end_date
ra_gw_filter$days_since_gw <- str_replace(ra_gw_filter$days_since_gw, " days", "")
ra_gw_filter$days_since_gw <- as.numeric(ra_gw_filter$days_since_gw)

#filter for one year before to one year after the giveaway ended 
ra_gw_filter_days <- ra_gw_filter %>% filter(days_since_gw >= -360 & days_since_gw <= 360)

#assign rows to bins of 30 days interval 
ra_gw_filter_days$bins <- cut_interval(ra_gw_filter_days$days_since_gw,length=30)

#put ratings to numeric variable 
ra_gw_filter_days$ratings <- as.numeric(ra_gw_filter_days$ratings)

#group rows by bins and count amount of ratings per bin 
ra_gw_graph <- ra_gw_filter_days %>% group_by(bins) %>% count()


#create plot 1 for number of ratings 
plot1 <- ggplot(data=ra_gw_graph, aes(x=bins, y=n, group=1))+
  geom_line() + 
  geom_vline(xintercept = "(-30,0]", 
             color = "blue") +
  geom_vline(xintercept = "(0,30]", 
             color = "blue") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(hjust=1, angle=90),
        plot.title = element_text(hjust = 0.5)) +
  xlab("Days Since End of Giveaway") +
  ylab("Number of Ratings") + 
  ggtitle("Number of Ratings per 30-days over time")


#read data for second plot, estimation sample 3
graph_data <- read.csv("../Estimation_samples/est_3.csv")

#transform date variables  
graph_data$time <- as.Date(graph_data$time)
graph_data_filter <- graph_data %>% filter(graph_data$time >= "2015-01-01")
graph_data_filter$giveaway_end_date <- as.Date(graph_data_filter$giveaway_end_date)


#create variable days since giveaway 
graph_data_filter$days_since_giveaway <- graph_data_filter$time - graph_data_filter$giveaway_end_date
graph_data_filter$days_since_giveaway <- str_replace(graph_data_filter$days_since_giveaway, " days", "")
graph_data_filter$days_since_giveaway <- as.numeric(graph_data_filter$days_since_giveaway)


#filter data from one year before end of giveaway to one year after end of giveaway
graph_data_filter_days <- graph_data_filter %>% filter(days_since_giveaway >= -360 & days_since_giveaway <= 360)

#create bins for 30 days interval 
graph_data_filter_days$bins <- cut_interval(graph_data_filter_days$days_since_giveaway,length=30)

graph_data_filter_days$ratings <- as.numeric(graph_data_filter_days$ratings)
graph_data_filter_days$treated <- ifelse(graph_data_filter_days$treated == "0", "No", "Yes")
graph_data_filter_days$treated <- as.factor(graph_data_filter_days$treated)

#group rows per bin and count amount of ratings
graph_data_plot <- graph_data_filter_days %>% group_by(treated, bins) %>% count()


#create second plot 
plot2 <- ggplot(data=graph_data_plot, aes(x=bins, y=n, group=treated, colour=treated))+
  geom_line() + 
  geom_vline(xintercept = "(0,30]", 
             color = "blue") +
  geom_vline(xintercept = "(-30,0]", 
             color = "blue") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(hjust=1, angle=90),
        plot.title = element_text(hjust = 0.5)) +
  xlab("Days Since End of Giveaway") +
  ylab("Number of Ratings") + 
  ggtitle("Number of Ratings per 30-days over time") + 
  labs(color="Giveaway Book?")


pdf(file = "../Plots/#Ratings.pdf")
grid.arrange(plot1, plot2, ncol=2)
dev.off()

grid.arrange(plot1, plot2, ncol=2)
