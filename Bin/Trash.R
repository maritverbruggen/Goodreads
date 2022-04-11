#Calculate and Visualize amount of Ratings per Day
review$ratings_counter <- as.numeric(review$ratings_counter)
review_week <- review %>% 
  group_by(week = lubridate::floor_date(time_form, "week")) %>%
  summarize(summary_variable = sum(ratings_counter))
review_week$cumsum <- cumsum(review_week$summary_variable)

ggplot(review_week, aes(x=week, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2017-01-01','2021-06-01'))) + 
  ylab("Amount of Ratings per Week") + xlab("Year")
View(review_week)

ggplot(review_week, aes(x=week, y=cumsum)) + geom_line() + 
  scale_x_date(date_breaks = "1 year",
               labels = date_format("%Y"),
               limit = as.Date(c('2015-01-01','2021-06-01')))+
  ylab("Cumulative Ratings") + xlab("Year")