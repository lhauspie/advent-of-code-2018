#!/usr/bin/env Rscript
Fibonacci <- function(n){
    a <- 0
    b <- 1
    for (i in 1:n){
        temp <- b
        b <- a
        a <- a + temp
    }
    return(a)
}

print(Fibonacci(5))