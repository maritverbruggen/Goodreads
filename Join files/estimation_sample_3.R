library(dplyr)
library(tidyverse)

#read similar files 
rm(list=ls())
similar_map <- read.csv("../Datasets/similar_map_thesis.csv")
similar_meta <- read.csv("../Datasets/similar_meta_thesis.csv")
giveways <- read.csv("../Datasets/giveaways_thesis.csv")

