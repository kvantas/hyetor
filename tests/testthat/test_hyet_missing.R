context("hyet_missing related tests")

test_that("hyet_missing returns error", {
  hyet <- "a"
  expect_error(hyet_missing(hyet))
})

test_that("hyet_missing reports correct ratios", {

  # create time series with 10 minutes time step
  time_step <- 60

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = 24,
      by = paste(time_step, "mins")
    ),
    prec = runif(24, 0, 5)
  )

  # expect reported NA monthly ratio = 0
  exp_miss <- tibble::tibble(year = 2018, month = 1, na_ratio = 0)
  expect_equal(object = hyet_missing(hyet), expected = exp_miss)

  # remove some records, NA monthly ratio = 0.125
  hyet_miss <- hyet[-c(2:4), ]
  hyet_miss <- hyet_fill(hyet_miss, 60)
  exp_miss <- tibble::tibble(year = 2018, month = 1, na_ratio = 0.125)
  expect_equal(object = hyet_missing(hyet_miss), expected = exp_miss)
})
