test_that("Test getPowerOf(3, 5, 8)",{
    expect_equal(getPowerOf(3, 5, 8), 4)
})

test_that("Test getPowerOf(122, 79, 57)",{
    expect_equal(getPowerOf(122, 79, 57), -5)
})

test_that("Test getPowerOf(217, 196, 39)",{
    expect_equal(getPowerOf(217, 196, 39), 0)
})

test_that("Test getPowerOf(101, 153, 71)",{
    expect_equal(getPowerOf(101, 153, 71), 4)
})

test_that("Test initPowerCells(18)", {
    m <- initPowerCells(18)[32:36, 44:48]
    expect_equal(initPowerCells(18)[32:36, 44:48], matrix(
        c(-2, -4,  4,  4,  4,
          -4,  4,  4,  4, -5,
           4,  3,  3,  4, -4,
           1,  1,  2,  4, -3,
          -1,  0,  2, -5, -2), ncol = 5, nrow = 5))
})

test_that("Test getMaxOfSize() of small grid", {
    powerCells <- matrix(
        c(-2, -4,  4,  4,  4,
          -4,  4,  4,  4, -5,
           4,  3,  3,  4, -4,
           1,  1,  2,  4, -3,
          -1,  0,  2, -5, -2), ncol = 5, nrow = 5)

    coord <- getMaxOfSize(powerCells, 3)
    expect_equal(coord$x, 2)
    expect_equal(coord$y, 2)
})

test_that("Test getMaxOfSize() of grid serial number 18", {
    powerCells <- initPowerCells(18)
    coord <- getMaxOfSize(powerCells, 3)

    expect_equal(coord$x, 33)
    expect_equal(coord$y, 45)
})

test_that("Test getMaxOfSize() of grid serial number 42", {
    powerCells <- initPowerCells(42)
    coord <- getMaxOfSize(powerCells, 3)

    expect_equal(coord$x, 21)
    expect_equal(coord$y, 61)
})


# test_that("matrix", {
#     m <- matrix(sample(1:15), 10, 10)
#     print(m)
#     print(m[1:3,1:3])
#     print(m)
#     print(sum(m[1:3,1:3]))

#     m <- matrix(, nrow=10, ncol=10)
#     print(m)
# })

