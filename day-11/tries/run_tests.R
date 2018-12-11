library(testthat)

source("src/fibo.R")

test_results <- test_dir("test", reporter="summary")