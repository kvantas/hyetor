context("huff_class related tests")

test_that("huff_class classifies simple hyetographs", {

  # create time series with 30 mins time step
  time_step <- 30
  len <- 12
  ts_unit <- "mins"

  # first quartile
  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = c(
      1.1, 22.3, 3.2,
      1.9, 4.1, 5.9,
      2.5, 3.1, 2.9,
      1.2, 1.1, 1
    )
  )

  res <- rain_quartiles(hyet, time_step, ts_unit)

  expect_equal(res$cum_prec, sum(hyet$prec))
  expect_equal(as.numeric(res$duration), 6)
  expect_equal(res$int_mean, sum(hyet$prec) / 6)
  expect_equal(res$quartile, 1)

  # second quartile
  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = c(
      1.1, 1.3, 3.2,
      1.9, 40.1, 5.9,
      2.5, 3.1, 2.9,
      1.2, 1.1, 1
    )
  )

  res <- rain_quartiles(hyet, time_step, ts_unit)
  expect_equal(res$quartile, 2)

  # third quartile
  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = c(
      1.1, 1.3, 3.2,
      1.9, 0.1, 5.9,
      2.5, 30.1, 2.9,
      1.2, 1.1, 1
    )
  )

  res <- rain_quartiles(hyet, time_step, ts_unit)
  expect_equal(res$quartile, 3)

  # fourth quartile
  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01 00:00:00", tz = "UTC"),
      length.out = len,
      by = paste(time_step, "mins")
    ),
    prec = c(
      1.1, 1.3, 3.2,
      1.9, 0.1, 5.9,
      2.5, 3.1, 2.9,
      1.2, 50.1, 1
    )
  )

  res <- rain_quartiles(hyet, time_step, ts_unit)
  expect_equal(res$quartile, 4)
})
