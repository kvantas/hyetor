context("hyet_aggregate related tests")

test_that("hyet_aggregate works", {

  # create time series with 30 mins time step
  time_step <- 30
  ts_unit <- "mins"
  len <- 4

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )


  expect_equal(
    nrow(hyet_aggregate(hyet, time_step = 1, ts_unit = "hours")),
    3
  )

  # create time series with 30 mins time step
  time_step <- 1
  ts_unit <- "days"
  len <- 50

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01", tz = "UTC"),
      length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )

  expect_equal(
    nrow(hyet_aggregate(hyet, time_step = 1, ts_unit = "months")),
    3
  )
})
