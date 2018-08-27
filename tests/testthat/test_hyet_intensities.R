context("hyet_intensities related tests")

test_that("hyet_intensities works with simple hyetographs", {
  time_step <- 30
  ts_unit <- "mins"
  len <- 12

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = seq(1, 12, 1)
  )

  intens <- hyet_intensities(hyet, time_step, ts_unit)

  expect_equal(as.numeric(intens$duration), 6)
  expect_equal(intens$cum_prec, sum(hyet$prec))
  expect_equal(intens$int_mean, sum(hyet$prec) / 6)

  # expect NA values
  expect_true(all(is.na(intens[c("int_5min", "int_10min", "int_15min")])))
  expect_true(all(is.na(intens[c("int_24hr", "int_48hr")])))

  # compute max intensities
  expect_equal(intens$int_30min, max(hyet$prec) * 2)
  expect_equal(intens$int_1hr, sum(hyet$prec[11:12]))
  expect_equal(intens$int_3hr, sum(hyet$prec[7:12]) / 3)
  expect_equal(intens$int_6hr, sum(hyet$prec[1:12]) / 6)
})

test_that("hyet_intensities works with grouped hyetographs", {
  time_step <- 1
  ts_unit <- "hours"
  len <- 18

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = seq(1, 18, 1)
  )

  # add a dry period
  hyet$prec[5:10] <- 0

  # split
  storms <- hyet_split(hyet, time_step, ts_unit)
  intens <- hyet_intensities(storms, time_step, ts_unit)

  # two storms exist
  expect_equal(nrow(intens), 2)
})

skip_on_appveyor()
skip_on_cran()
skip_on_travis()
test_that("hyet_intensities push", {
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

  hyet$year <- lubridate::year(hyet$date)

  hyet <- dplyr::group_by(hyet, year)

  expect_equal(nrow(hyet_intensities(hyet, time_step, ts_unit)), 100)
})
