function printsum(a)
    # summary generates a summary of an object
    println(summary(a), ": ", repr(a))
end

matrix = zeros(Int8, 2, 3)
printsum(matrix)
matrix[1,1] = 5
printsum(matrix)

@show matrix

