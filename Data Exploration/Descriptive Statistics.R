

df_uniq <- unique(full_data$giveaway_id)
length(df_uniq)

#descriptive statistics for rating
mean(full_data$ratings.x)
sd(full_data$ratings.x)
min(full_data$ratings.x)
max(full_data$ratings.x)

#descriptive statistics for review length (words)
full_data$review_words <- str_count(full_data$text, "\\w+")
mean(full_data$review_words, na.rm=TRUE)
sd(full_data$review_words, na.rm=TRUE)
max(full_data$review_words, na.rm=TRUE)

#descriptive statistics for giveaways 
full_data$giveaway_duration <- full_data$giveaway_end_date - full_data$giveaway_start_date
full_data$giveaway_end_date <- as.Date(full_data$giveaway_end_date, na.rm=TRUE)
memory.limit(10000)

