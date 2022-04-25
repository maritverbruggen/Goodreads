library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(fixest)
library(pdftools)

rm(list=ls())
memory.limit(size=1000000)
memory.limit()

#read data 
graph_data <- read.csv("../Estimation_samples/.csv")
