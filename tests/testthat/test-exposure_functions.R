context("test-exposure_functions")

#A record with a non-unique key, not allowable input.
record_bad_key <- data.frame(key = rep("A", 2), start = rep(as.Date("2000-01-01"), 2), end = rep(as.Date("2001-02-10"), 2), stringsAsFactors = FALSE)

test_that("Non-unique key returns error", {
  expect_error(addExposures(record_bad_key), "Key is not unique") })

#A record with all end dates before start dates returns an error, if some end dates are before
#start dates a warning will be given and the appropriate exposure frame will be returned for
#the good policies.
one_record_late_start <- data.frame(key = "B", start = as.Date("2002-06-15"), end = as.Date("2001-07-25"), stringsAsFactors = FALSE)
two_records_one_late <- data.frame(key = c("A", "B"),
                                   start = c(as.Date("2000-01-01"), as.Date("2002-06-15")),
                                   end = c(as.Date("2001-02-10"), as.Date("2001-07-25")),
                                   stringsAsFactors = FALSE)

test_that("Correct handling of end dates prior to start dates", {
  expect_error(addExposures(one_record_late_start), "All records have end dates before start dates")
  expect_equivalent(addExposures(two_records_one_late), good_PY)
})


#A record where policy months/years won't end at the same time as calendar months/years.
record_mid <- data.frame(key = "A", start = as.Date("2000-06-15"), end = as.Date("2001-07-25"), stringsAsFactors = FALSE)
#A record where policy months/years will end at the same time as calendar months/years.
record_start <- data.frame(key = "A", start = as.Date("2000-01-01"), end = as.Date("2001-02-10"), stringsAsFactors = FALSE)

#Test all of the functions against the expected output in helper_data.R
test_that("Policy year exposure calculation works", {
  expect_equivalent(addExposures(record_start, type = "PY"), good_PY)
})

test_that("Policy month exposure calculation works", {
  expect_equivalent(addExposures(record_start, type = "PM"), good_PM)
})

test_that("Policy year with calendar year exposure calculation works, mid and start", {
  expect_equivalent(addExposures(record_mid, type = "PYCY"), good_PYCY_mid)
  expect_equivalent(addExposures(record_start, type = "PYCY"), good_PYCY_start)
})

test_that("Policy year with calendar month exposure calculation works, mid and start", {
  expect_equivalent(addExposures(record_mid, type = "PYCM"), good_PYCM_mid)
  expect_equivalent(addExposures(record_start, type = "PYCM"), good_PYCM_start)
})

test_that("Policy month with calendar year exposure calculation works, mid and start", {
  expect_equivalent(addExposures(record_mid, type = "PMCY"), good_PMCY_mid)
  expect_equivalent(addExposures(record_start, type = "PMCY"), good_PMCY_start)
})

test_that("Policy month with calendar month exposure calculation works, mid and start", {
  expect_equivalent(addExposures(record_mid, type = "PMCM"), good_PMCM_mid)
  expect_equivalent(addExposures(record_start, type = "PMCM"), good_PMCM_start)
})


#Very old policies for testing the lower truncation year functionality.
old_record_mid <- data.frame(key = "A", start = as.Date("1800-06-15"), end = as.Date("2001-07-25"), stringsAsFactors = FALSE)
old_record_start <- data.frame(key = "A", start = as.Date("1800-01-01"), end = as.Date("2001-02-10"), stringsAsFactors = FALSE)

test_that("lower_year argument works for truncation", {
  expect_equal(nrow(addExposures(old_record_mid, type = "PY", lower_year = 2002)), 0)
  expect_equivalent(addExposures(old_record_mid, type = "PY", lower_year = 2000), good_old_PY)
  expect_equivalent(addExposures(old_record_start, type = "PM", lower_year = 2000), good_old_PM)
  expect_equivalent(addExposures(old_record_mid, type = "PYCY", lower_year = 2000), good_old_PYCY)
  expect_equivalent(addExposures(old_record_start, type = "PYCM", lower_year = 2000), good_old_PYCM)
  expect_equivalent(addExposures(old_record_start, type = "PMCY", lower_year = 2000), good_old_PMCY)
  expect_equivalent(addExposures(old_record_start, type = "PMCM", lower_year = 2000), good_old_PMCM)
})
