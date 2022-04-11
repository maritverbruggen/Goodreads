

#clean author en book information file 
author <- subset(author, select=-c(author_role,author_link, author_ratings_count, author_reviews_count))
book_info <- subset(book_info, select=c(id, book_publication_date, title,average_rating, num_pages, ratings_count, text_reviews_count))
ratings <- subset(ratings, select =c(book_id, review_id, new_review_id, ratings, time))
giveaways <- subset(giveaways, select=c(giveaway_id, book_id, copy_n, request_n, giveaway_start_date, giveaway_end_date))




