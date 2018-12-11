test_that("Test Fibo(15)",{
  phi <- (1 + sqrt(5))/2
  psi <- (1 - sqrt(5))/2
  expect_equal(Fibonacci(15), (phi**15 - psi**15)/sqrt(5))
})

