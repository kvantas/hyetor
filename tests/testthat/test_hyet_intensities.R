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

  # expect NA values
  expect_true(all(is.na(intens$intensity[1:3])))

  # compute max intensities
  expect_equal(intens$intensity[4], max(hyet$prec) * 2)
  expect_equal(intens$intensity[5], sum(hyet$prec[11:12]))
  expect_equal(intens$intensity[6], sum(hyet$prec[7:12]) / 3)
  expect_equal(intens$intensity[7], sum(hyet$prec[1:12]) / 6)
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
  expect_equal(tail(intens$storm, 1), 2)
})

skip_on_appveyor()
skip_on_cran()
skip_on_travis()
test_that("hyet_intensities, 1 year", {
  time_step <- 5
  ts_unit <- "mins"
  len <- 12 * 24 * 365

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "1918-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len)
  )

  hyet$year <- lubridate::year(hyet$date)

  hyet <- dplyr::group_by(hyet, year)

  expect_true(!is.null(hyet_intensities(hyet, time_step, ts_unit)))
})
