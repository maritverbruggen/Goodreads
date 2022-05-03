library(readr)    
library(dplyr)    
library(tidyr)     
library(tidygraph) 
library(ggraph)
library(data.table)
library(plm)
library(fixest)
library(stringr)

rm(list=ls())
memory.limit(size=1000000)

did <- read.csv("../Estimation_samples/est_3.csv")

did$time <- as.Date(did$time)
did$giveaway_end_date <- as.Date(did$giveaway_end_date)
did <- did %>% filter(time >= "2015-01-01")

#create variable days since giveaway 
did$days_since_gw <- did$time - did$giveaway_end_date 
did$days_since_gw <- str_replace(did$days_since_gw, " days", "")
did$days_since_gw <- as.numeric(did$days_since_gw)

#filter for year before and year after 
did_days <- did %>% filter(days_since_gw >= -360 & days_since_gw <= 360)

#create bins of 30-day periods 
did_days$bin <- cut_interval(did_days$days_since_gw, length=30)

#reformat treated variable for graph 
did_days$treated <- ifelse(did_days$treated == "0", "No", "Yes")

#create table for plot 
did_plot <- did_days %>% group_by(treated, bin) %>% count()

ggplot(data=did_plot, aes(x=bin, y=n, group=treated, colour=treated))+
  geom_line() + 
  geom_vline(xintercept = "(-30,0]", 
             color = "blue") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(hjust=1, angle=90),
        plot.title = element_text(hjust = 0.5)) +
  xlab("Days Since End of Giveaway") +
  ylab("Number of Ratings") + 
  ggtitle("Number of Ratings per 30-days over time") + 
  labs(color="Giveaway Book?")



##prepare did estimation sample for regression 

did$month <- format(did$time, "%Y-%m")
did$gw_month <- format(did$giveaway_end_date, "%Y-%m")

did_count <- did %>% count(focal_book_id, month, gw_month, treated, post)
View(did_count)


gravity_subfe = list()
all_FEs = c("focal_book_id", "month")
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(n ~ post *treated , did_count, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~focal_book_id)

did 
