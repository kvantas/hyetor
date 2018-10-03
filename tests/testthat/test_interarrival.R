context("interarrival related tests")

test_that("interarrival works with a simple hyetogrpah", {

  # create time series with 30 mins time step
  time_step <- 2
  len <- 18
  ts_unit <- "hours"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = c(
      1,
      0, 0, 0,
      2, 1, 2,
      0, 0, 0, 0,
      3, 1, 2,
      0, 0, 0,
      2
    )
  )

  # split hyet to storms using 6 hours of CD
  storms <- hyet_split(hyet, time_step, ts_unit)

  int_times <- interarrival(storms)

  expect_equal(as.numeric(int_times$inter_period), c(0, 8, 14, 12))
  expect_equal(as.numeric(int_times$dry_period), c(0, 8, 10, 8))
})
