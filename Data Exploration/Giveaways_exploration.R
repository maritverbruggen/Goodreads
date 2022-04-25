library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)


rm(list=ls())
memory.limit(size=1000000)

#read data
giveaways <- read.csv("../Datasets/giveaways_df.csv")
#view data
View(giveaways)

names(giveaways)

#check min and max giveaway end date 
giveaways$giveaway_end_date <- as.Date(giveaways$giveaway_end_date)
giveaways$giveaway_start_date <- as.Date(giveaways$giveaway_start_date)
min(giveaways$giveaway_end_date)
max(giveaways$giveaway_end_date)

#check amount of unique books that performed giveaway 
df_uniq <- unique(giveaways$book_id)
length(df_uniq)
sum(is.na(giveaways$giveaway_start_date))

#calculate mean amount of copies in a giveaway
giveaways$month <- format(giveaways$giveaway_end_date, "%m-%Y")
head(giveaways)
giveaways$month <- as.Date(giveaways$month, "%m-%Y")
head(giveaways)

gw_graph <- giveaways %>% group_by(month) %>% count()
mean(gw_graph$n)
View(gw_graph)

gw_graph <- gw_graph %>% filter(month != "01-2018")
gw_graph <- gw_graph %>% filter(month != "11-2020")

mean(gw_graph$n)
sd(gw_graph$n)
min(gw_graph$n)
max(gw_graph$n)

ggplot(gw_graph, aes(x=month, y=n, group=1)) + geom_line()

ggplot(giveaways, aes(x=lubridate::floor_date(giveaway_end_date, "month"))) +
  geom_bar()+ 
  xlab("Giveaway End Date grouped by Month") + 
  ylab("Number of Giveaways") + 
  geom_hline(yintercept = 814.2857,color="red")


#cumulative giveaways grouped by month 
giveaways_month$cumsum <- cumsum(giveaways_month$summary_variable)
ggplot(giveaways_month, aes(x=month, y=cumsum)) + geom_line() +
  scale_x_date(date_breaks = "year",
               labels=date_format("%Y"),
               limits = as.Date(c('2017-01-01','2020-12-31'))) + 
  ylab("Total amount of Giveaways") + xlab("Year")


#calculate discriptive statistics for amount of giveaways per month 
mean(giveaways_month$summary_variable)
sd(giveaways_month$summary_variable)
min(giveaways_month$summary_variable)
max(giveaways_month$summary_variable)
View(giveaways_month)

     