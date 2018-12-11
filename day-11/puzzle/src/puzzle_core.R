getPowerOf <- function(x,y,n) {
    rackId = (x+10)
    ( trunc( ( ( (rackId * y) + n ) * rackId ) / 100 ) %% 10 ) - 5
}

initPowerCells <- function(n) {
    powerCells <- matrix(, nrow = 300, ncol = 300)
    for (x in c(1:300)){
        for (y in c(1:300)){
            powerCells[x,y] <- getPowerOf(x, y, n)
        }
    }
    powerCells
}

getMaxOfSize <- function(power_cells, size) {
    max_sum <- -2147483647
    max_x <- 0
    max_y <- 0
    for (x in c(1:(ncol(power_cells)-size+1))) {
        for (y in c(1:(nrow(power_cells)-size+1))) {
            sum <- sum(power_cells[x:(x+size-1), y:(y+size-1)])
            if (sum > max_sum) {
                max_sum <- sum
                max_x <- x
                max_y <- y
            }
        }
    }
    list("sum" = max_sum, "x" = max_x, "y" = max_y)
}

getMax <- function(power_cells) {
    max_sum <- -2147483647
    max_x <- 0
    max_y <- 0
    max_size <- 0
    
    for (size in c(1:300)) {
        sum <- getMaxOfSize(power_cells, size)
        if (sum$sum > max_sum) {
            max_sum <- sum$sum
            max_x <- sum$x
            max_y <- sum$y
            max_size <- size
        }
        print(paste("dealing with square of size of ", size))
    }
    list("x" = max_x, "y" = max_y, "size" = max_size)
}

puzzle1 <- function(n) {
    max <- getMaxOfSize(initPowerCells(n), 3)
    paste(max$x, ",", max$y)
}

puzzle2 <- function(n) {
    max <- getMax(initPowerCells(n))
    paste(max$x, ",", max$y, ",", max$size)
}