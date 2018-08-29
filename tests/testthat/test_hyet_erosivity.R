context("hyet_erosivity related tests")

test_that("hyet_erosivity works with simple hyetographs", {

  # create time series with 30 mins time step
  time_step <- 30
  len <- 12
  en_equation <- "brown_foster"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = c(1.1, 2.3, 3.2, 1.9, 4.1, 5.9, 2.5, 3.1, 2.9, 1.2, 0.5, 0.2)
  )

  ei_values <- hyet_erosivity(hyet, time_step, en_equation)

  # expect to return a single erosivity event
  expect_equal(NROW(ei_values), 1)
})

test_that("hyet_erosivity works with grouped hyetographs", {

  # create time series with 5 mins time step
  time_step <- 5
  len <- 190
  en_equation <- "brown_foster"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = rep(5, len)
  )

  # add a six-hour break
  hyet$prec[10:82] <- 0.

  # add a period of six hours with cum_prec < 1.27 mm
  hyet$prec[110:182] <- 0.01

  # create grouped hyet
  storms <- hyet_split(hyet, time_step, "mins")

  # copmute ei_values
  ei_values <- hyet_erosivity(storms, time_step, en_equation)

  # expect to return three erosivity events
  expect_equal(nrow(ei_values), 3)
})

test_that("hyet_erosivity works for 10 min time step", {

  # create time series with 10 mins time step
  time_step <- 10
  len <- 190
  en_equation <- "brown_foster"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = rep(5, len)
  )

  # add a six-hour break
  hyet$prec[10:46] <- 0.

  # add a period of six hours with cum_prec < 1.27 mm
  hyet$prec[110:146] <- 0.01

  # create grouped hyet
  storms <- hyet_split(hyet, time_step, "mins")

  # copmute ei_values
  ei_values <- hyet_erosivity(storms, time_step, en_equation)

  # expect to return three erosivity events
  expect_equal(nrow(ei_values), 3)
})

test_that("hyet_erosivity works for 15 min time step", {

  # create time series with 10 mins time step
  time_step <- 15
  len <- 190
  en_equation <- "brown_foster"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = rep(5, len)
  )

  # add a six-hour break
  hyet$prec[10:34] <- 0.

  # add a period of six hours with cum_prec < 1.27 mm
  hyet$prec[110:134] <- 0.01

  # create grouped hyet
  storms <- hyet_split(hyet, time_step, "mins")

  # copmute ei_values
  ei_values <- hyet_erosivity(storms, time_step, en_equation)

  # expect to return three erosivity events
  expect_equal(nrow(ei_values), 3)
})


skip_on_appveyor()
skip_on_cran()
skip_on_travis()
test_that("push hyet_erosivity, 5 mins time-step", {
  time_step <- 5
  ts_unit <- "mins"
  len <- 12 * 24 * 365 * 100

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "1918-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len)
  )

  # set to zero 90 % of prec
  hyet$prec[sample(1:len, len * 0.9)] <- 0

  expect_true("tbl_df" %in% class(hyet_erosivity(hyet, time_step)))
})

skip_on_appveyor()
skip_on_cran()
skip_on_travis()
test_that("push hyet_erosivity, 30 mins time-step", {
  time_step <- 30
  ts_unit <- "mins"
  len <- 2 * 24 * 365 * 100

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "1918-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len)
  )

  # set to zero 90 % of prec
  hyet$prec[sample(1:len, len * 0.9)] <- 0

  expect_true("tbl_df" %in% class(hyet_erosivity(hyet, time_step)))
})
