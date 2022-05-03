library(readr)    
library(dplyr)    
library(tidyr)     
library(tidygraph) 
library(ggraph)
library(data.table)
library(plm)
library(fixest)
library(stringr)

memory.limit(size=1000000)
rm(list=ls())

did <- read.csv("../Estimation_samples/est_3.csv")

did$time <- as.Date(did$time)
did <- did %>% filter(time >= "2015-01-01")

#amount of observations per group
groups <- did %>% group_by(treated, post) %>% count()
View(groups)

#change month variable 
did$month <- format(did$time, "%Y-%m")
did_treat <- did %>% filter(treated == "1")
did_non <- did %>% filter(treated == "0")

length(unique(did_treat$similar_book_id))
length(unique(did_non$similar_book_id))

#descriptive statistics giveaway books
mean(did_treat$ratings)
sd(did_treat$ratings)

mean(did_non$ratings)
sd(did_non$ratings)

#group by month 

did_month_treat <- did_treat %>% group_by(month) %>% count()
did_month_non <- did_non %>% group_by(month) %>% count()

did_month_treat <- did_month_treat[1:76,]
mean(did_month_treat$n)
sd(did_month_treat$n)
min(did_month_treat$n)
max(did_month_treat$n)

View(did_month_non)
mean(did_month_non$n)
sd(did_month_non$n)
min(did_month_non$n)
max(did_month_non$n)
sum(did_month_non$n)



#create graph 

#factor dummy variables 
did$treated <- as.factor(did$treated)

#create variable days since giveaway 
did$giveaway_end_date <- as.Date(did$giveaway_end_date)
did$days_since_giveaway <- did$time - did$giveaway_end_date
did$days_since_giveaway <- str_replace(did$days_since_giveaway, " days", "")
did$days_since_giveaway <- as.numeric(did$days_since_giveaway)


did_days <- did %>% filter(days_since_giveaway >= -360 & days_since_giveaway <= 360)
max(did_days$days_since_giveaway)

did_days$days_since_gw_bin <- cut_interval(did_days$days_since_giveaway,length=30)
did_days$treated <- ifelse(did_days$treated == "0", "No", "Yes")

graph_data_plot <- did_days %>% group_by(treated, days_since_gw_bin) %>% summarise(mean = mean(ratings))
View(graph_data_plot)

pdf(file = "../Plots/Starrating.pdf")

ggplot(data=graph_data_plot, aes(x=days_since_gw_bin, y=mean, group=treated, colour=treated))+
    geom_line() + 
    geom_vline(xintercept = "(-30,0]", 
               color = "blue") +
    theme(text = element_text(size=10),
          axis.text.x = element_text(hjust=1, angle=90),
          plot.title = element_text(hjust = 0.5)) +
    xlab("Days Since End of Giveaway") +
    ylab("Average Star Rating") + 
    ggtitle("Average Star Rating per 30-days over Time") + 
    labs(color="Giveaway Book?")
dev.off()


## Analysis 

did$period <- did$days_since_giveaway / 30
head(did)


did$period <- as.numeric(did$period)

did_filter <- did %>% filter(period <= 12 & period >= -12)
min(did_filter$period)
did_filter$period <- round(did_filter$period)


first <- feols(ratings ~ post + i(period,treated, 0) | focal_book_id + period, did_filter)
iplot(first)
?iplot

gravity_subfe = list()
all_FEs = c("focal_book_id", "month")
for(i in 0:2){
  gravity_subfe[[i+1]] = feols(ratings ~ post *treated , did, fixef = all_FEs[0:i])
}
etable(gravity_subfe, cluster = ~focal_book_id)
