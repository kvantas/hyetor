context("rain_energy related tests")

test_that("rain_energy returns correct values", {

  # NA or NULL value return NA
  expect_true(is.na(rain_energy(NA)))
  expect_true(is.na(rain_energy(NULL)))

  # test values
  i1 <- 1
  i2 <- 77

  # brown_foster equation
  expect_equal(
    rain_energy(intensity = i1, en_equation = "brown_foster"),
    0.29 * (1 - 0.72 * exp(-0.05 * i1))
  )

  # mc_gregor equation
  expect_equal(
    rain_energy(intensity = i1, en_equation = "mcgregor_mutch"),
    0.29 * (1 - 0.72 * exp(-0.082 * i1))
  )

  # laws_parson
  expect_equal(
    rain_energy(intensity = i1, en_equation = "wisch_smith"),
    0.119 + 0.0873 * log10(i1)
  )
  expect_equal(
    rain_energy(intensity = i2, en_equation = "wisch_smith"),
    0.283
  )
})
