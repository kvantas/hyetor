context("erosivity related tests")

test_that("erosivity returns correct values for 30 min time step", {

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

  # compute EI values
  ei_values <- erosivity(hyet, time_step, en_equation)

  # check values
  expect_equal(as.numeric(ei_values$duration, units = "mins"), time_step * len)
  expect_equal(ei_values$cum_prec, sum(hyet$prec))
  expect_equal(ei_values$max_i30, max(hyet$prec) * 2)

  ei <- sum(hyet$prec * rain_energy(intensity = hyet$prec * 2)) *
    max(hyet$prec) * 2
  expect_equal(ei_values$erosivity, ei)
})

test_that("erosivity returns correct values for 5 min time step", {

  # create time series with 30 mins time step
  time_step <- 5
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

  # compute EI values
  ei_values <- erosivity(hyet, time_step, en_equation)

  # check values
  expect_equal(as.numeric(ei_values$duration, units = "mins"), time_step * len)
  expect_equal(ei_values$cum_prec, sum(hyet$prec))

  max_i30 <- max_roll_sum(hyet, from_dur = "5 mins", to_dur = "30 mins") * 2
  max_i15 <- max_roll_sum(hyet, from_dur = "5 mins", to_dur = "15 mins") * 4

  expect_equal(ei_values$max_i30, max_i30)
  expect_equal(ei_values$max_i15, max_i15)

  ei <- sum(hyet$prec * rain_energy(intensity = hyet$prec * 12)) *
    max_i30
  expect_equal(ei_values$erosivity, ei)
})

test_that("erosivity breaks storms", {

  # create time series with 30 mins time step
  time_step <- 5
  len <- 100
  en_equation <- "brown_foster"

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

  # compute EI values
  ei_values <- erosivity(hyet, time_step, en_equation)

  expect_true(NROW(ei_values) == 2)
})
