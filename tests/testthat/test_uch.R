context("uch related tests")

test_that("uch returns correct values", {

  # create time series with 30 mins time step
  time_step <- 30
  ts_unit <- "mins"
  len <- 12
  nvalues <- 20

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, ts_unit)
    ),
    prec = runif(len, 1, 5)
  )

  uch_list <- uch(hyet, time_step, ts_unit, nvalues)

  # test duration, total prec and ranges
  expect_equal(as.numeric(uch_list$duration), time_step * len)
  expect_equal(uch_list$prec_height, sum(hyet$prec))
  expect_true(all(uch_list$hyet_approx$unit_time >= 0) &
    all(uch_list$hyet_approx$unit_time <= 1))
  expect_true(all(uch_list$hyet_approx$unit_prec >= 0) &
    all(uch_list$hyet_approx$unit_prec <= 1))
  expect_equal(nrow(uch_list$hyet_approx), nvalues)
})
