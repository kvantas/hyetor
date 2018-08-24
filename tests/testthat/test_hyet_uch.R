context("hyet_uch related tests")

test_that("hyet_uch works with simple hyetographs", {

  # create time series with 30 mins time step
  time_step <- 30
  len <- 12
  ts_unit <- "mins"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = c(1.1, 2.3, 3.2, 1.9, 4.1, 5.9, 2.5, 3.1, 2.9, 1.2, 0.5, 0.2)
  )

  uch_vals <- hyet_uch(hyet, time_step, ts_unit)

  # expect to return a single erosivity event
  expect_equal(NROW(uch_vals), 1)
})

test_that("hyet_uch works with grouped hyetographs", {

  # create time series with 5 mins time step
  time_step <- 5
  len <- 190
  ts_unit <- "mins"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = rep(2, len)
  )

  # add a six-hour break
  hyet$prec[10:82] <- 0.

  # create grouped hyet
  storms <- hyet_split(hyet, 5)

  # copmute UCHs
  uch_values <- hyet_uch(storms, time_step, ts_unit)

  # expect to return three erosivity events
  expect_equal(nrow(uch_values), 2)
})
