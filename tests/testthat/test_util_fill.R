context("util_fill related tests")

test_that("util_fill fills time series", {

  # create time series with 10 minutes time step
  time_step <- 10
  units <- "mins"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = 100,
      by = paste(time_step, units)
    ),
    prec = runif(100, 0, 5)
  )

  # remove some records
  hyet_miss <- hyet[-c(2:10, 14, 31, 70:80), ]

  # fill time series
  hyet_filled <- util_fill(hyet_miss, time_step, units)

  # date must match
  expect_equal(object = hyet_filled$date, expected = hyet$date)
})
