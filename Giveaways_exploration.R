library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

#read data
giveaways <- read.csv("../../Datasets/giveaways_thesis.csv")
#view data
View(giveaways)

#check min and max giveaway  start date 
giveaways$giveaway_end_date <- as.Date(giveaways$giveaway_end_date)
giveaways$giveaway_start_date <- as.Date(giveaways$giveaway_start_date)
min(giveaways$giveaway_start_date)
max(giveaways$giveaway_end_date)

#check amount of unique books that performed giveaway 
df_uniq <- unique(giveaways$book_id)
length(df_uniq)
sum(is.na(giveaways$giveaway_start_date))

#calculate duration of giveaways 
giveaways$diff_in_days<- difftime(giveaways$giveaway_end_date ,giveaways$giveaway_start_date , units = c("days"))
giveaways$diff_in_days<- str_replace(giveaways$diff_in_days, "days", "")
giveaways$diff_in_days <- as.numeric(giveaways$diff_in_days)
giveaways$diff_in_weeks <- giveaways$diff_in_days/7
table(giveaways$diff_in_days)
table(giveaways$diff_in_weeks)
mean(giveaways$diff_in_days)
mean(giveaways$diff_in_weeks)


#calculate mean amount of copies in a giveaway
table(giveaways$copy_n) %>% 
  as.data.frame() %>% 
  arrange(desc(Freq))
mean(giveaways$copy_n)
max(giveaways$copy_n)
min(giveaways$copy_n)
#amount of giveaways over time 
for (i in seq(1,length(giveaways$giveaway_id))){
  giveaways$giveaway_counter[i] <- "1"
}
giveaways$giveaway_counter <- as.numeric(giveaways$giveaway_counter)

#group by month 
giveaways_month <- giveaways %>% 
  group_by(month = lubridate::floor_date(giveaway_start_date, "month")) %>%
  summarize(summary_variable = sum(giveaway_counter))

#average amount of giveaways per month 
ggplot(giveaways_month, aes(x=month, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2017-01-01','2020-12-31'))) + 
  ylab("Amount of Giveaways per Month") + xlab("Year") + 
  geom_hline(yintercept=mean(giveaways_month$summary_variable), linetype="dashed", color = "red")

#cumulative giveaways grouped by month 
giveaways_month$cumsum <- cumsum(giveaways_month$summary_variable)
ggplot(giveaways_month, aes(x=month, y=cumsum)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2017-01-01','2020-12-31'))) + 
  ylab("Total amount of Giveaways") + xlab("Year")

mean(giveaways_month$summary_variable)
sd(giveaways_month$summary_variable)
