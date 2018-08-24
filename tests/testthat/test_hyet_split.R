context("hyet_split related tests")


test_that("hyet_split splits time series, units in hours", {

  # create time series with 1 hours time step
  time_step <- 1
  ts_unit <- "hours"
  len <- 30
  crit_dur <- rep(6, 12)

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )

  # create 2 dry durations of 6 hours
  hyet$prec[10:15] <- 0
  hyet$prec[21:26] <- 0

  # add some zeros
  hyet$prec[2:5] <- 0

  # split hyet
  storms <- hyet_split(hyet, time_step, ts_unit, crit_dur)

  # expect 3 storms
  expect_equal(tail(storms$storm, 1), 3)
})


test_that("hyet_split splits time series, units in mins", {

  # create time series with 30 mins time step
  time_step <- 30
  ts_unit <- "mins"
  len <- 90
  crit_dur <- rep(6, 12)

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )

  # create 2 dry durations >= 6 hours
  hyet$prec[10:23] <- 0
  hyet$prec[41:54] <- 0

  # add some zeros
  hyet$prec[2:5] <- 0

  # split hyet
  storms <- hyet_split(hyet, time_step, ts_unit, crit_dur)

  # expect 3 storms
  expect_equal(tail(storms$storm, 1), 3)
})
