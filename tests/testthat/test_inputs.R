context("input values related tests")

test_that("functions returns errors", {

  # not count
  expect_error(count_check("a", "var_name"))
  expect_error(count_check(0, "var_name"))
  expect_error(count_check(-1, "var_name"))

  # not valid units
  expect_error(units_check("days", minhour = TRUE))
  expect_error(units_check("none", minhour = FALSE))

  # not valid critical durations vector
  expect_error(crit_dur_check(1))
  expect_error(crit_dur_check(-5:6))
  expect_error(crit_dur_check(1:6))

  # not a valid energy equation
  expect_error(en_eq_check("none"))

  # not a valid time step for erosivity
  expect_error(vector_check(600))
})
