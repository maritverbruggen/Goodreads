library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(tidyverse)
library(data.table)

memory.limit()
memory.limit(size=1000000)
memory.limit()

sim_rat <- read.csv("../Datasets/similar_review.csv")

#reformat time variable 
sim_rat$time <- as.Date(sim_rat$time, format = "%Y-%m-%d")
sum(is.na(sim_rat$time))

