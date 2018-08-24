context("hyet_create related tests")

test_that("hyet_create returns errors", {

  # unequal lengths
  prec <- c(1.1, 2.1, 3.1)
  date <- seq(
    from = as.POSIXct(0, origin = "2018-01-01"),
    length.out = 2,
    by = "mins"
  )
  expect_error(hyet_create(date, prec))

  # non numeric prec
  prec <- c("a", "b")
  date <- seq(
    from = as.POSIXct(0, origin = "2018-01-01"),
    length.out = 2,
    by = "mins"
  )
  expect_error(hyet_create(date, prec))

  # non POSIXct date
  prec <- c(1.1, 2.1)
  date <- c("a", "b")
  expect_error(hyet_create(date, prec))

  # expect a tibble
  date <- seq(
    from = as.POSIXct(0, origin = "2018-01-01"),
    length.out = 100,
    by = "mins"
  )
  prec <- runif(100, 0, 10)
  expect_is(hyet_create(date, prec), "tbl_df")
})
