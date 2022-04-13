library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

#read data
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
#view data
View(giveaways)

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
table(giveaways$copy_n) %>% 
  as.data.frame() %>% 
  arrange(desc(Freq))
mean(giveaways$copy_n)
max(giveaways$copy_n)
min(giveaways$copy_n)
sd(giveaways$copy_n)
#amount of giveaways over time 
giveaways$giveaways_counter <- 1
giveaways$giveaways_counter <- as.numeric(giveaways$giveaways_counter)

#group by month 

giveaways_month <- giveaways %>% 
  group_by(month = lubridate::floor_date(giveaway_end_date, "month")) %>%
  summarize(summary_variable = sum(giveaways_counter))
giveaways_month <- giveaways_month[1:34,]

#average amount of giveaways per month 
ggplot(giveaways_month, aes(x=month, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2017-01-01','2020-10-01'))) + 
  ylab("Amount of Giveaways per Month") + xlab("Year") + 
  geom_hline(yintercept=mean(giveaways_month$summary_variable), linetype="dashed", color = "red") +
  ylim(0, 2500)


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

     