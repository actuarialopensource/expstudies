context("test-exposure_functions")
record_mid <- data.frame(key = "A", start = as.Date("2000-06-15"), end = as.Date("2001-07-25"))
record_start <- data.frame(key = "A", start = as.Date("2000-01-01"), end = as.Date("2001-02-10"))

# negative control-- this test should fail, because this will NOT throw an error
test_that("an invalid value for type errors", {
  expect_error(addExposures(record_mid, type = "PY")) })
# negative control-- this test should fail, because this will NOT throw an error
test_that("an invalid value for type errors", {
  expect_error(addExposures(record_mid, type = "PY")) })
# positive control-- this test should pass, because this WILL throw an error
test_that("an invalid value for type errors", {
  expect_error(addExposures(record_mid, type = "PYCY")) })
# positive control-- this test should pass, because this WILL throw an error
test_that("an invalid value for type errors", {
  expect_error(addExposures(record_mid, type = "PM")) })



