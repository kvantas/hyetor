context("rain_intensities related tests")

test_that("rain_intensities works for 5 minute time step", {

  # create constant time series with 5 mins time step. Constant int = 12 mm/hr
  time_step <- 5
  ts_unit <- "mins"
  len <- 12 * 24 * 12

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = 1
  )

  intens <- rain_intensities(hyet, 5, "mins")

  expect_equal(as.numeric(intens$duration), 12 * 24)
  expect_equal(intens$cum_prec, nrow(hyet))
  expect_true(all(intens[, 6:10] == 12))
})
