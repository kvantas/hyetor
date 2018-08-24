context("util_roll_sum related tests")

test_that("util_roll_sum works", {
  time_step <- 10
  units <- "mins"

  hyet <- tibble::tibble(
    date = seq(
      from = as.POSIXct(0, origin = "2018-01-01"), length.out = 10,
      by = paste(time_step, units)
    ),
    prec = 1:10
  )

  # if windows size is greater than records length return all NA
  expect_true(all(is.na(util_roll_sum(hyet, 11)$prec)))

  expect_equal(util_roll_sum(hyet, 2)$prec, c(seq(3, 19, 2), NA))
  expect_equal(util_roll_sum(hyet, 3)$prec, c(seq(6, 27, 3), NA, NA))
})
