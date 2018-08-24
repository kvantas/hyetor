context("hyet_fill related tests")

test_that("hyet_fill fills time series, hours", {

  # create time series with 1 hours time step
  time_step <- 1
  ts_unit <- "hours"
  len <- 90

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )

  # remove some records
  hyet_miss <- hyet[-c(2:10, 14, 31, 70:80), ]

  # fill time series
  hyet_filled <- hyet_fill(hyet_miss, time_step, ts_unit)

  # date must match
  expect_equal(object = hyet_filled$date, expected = hyet$date)
})

test_that("hyet_fill fills time series, mins", {

  # create time series with 10 mins time step
  time_step <- 10
  ts_unit <- "mins"
  len <- 90

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )

  # remove some records
  hyet_miss <- hyet[-c(2:10, 14, 31, 70:80), ]

  # fill time series
  hyet_filled <- hyet_fill(hyet_miss, time_step, ts_unit)

  # date must match
  expect_equal(object = hyet_filled$date, expected = hyet$date)
})
