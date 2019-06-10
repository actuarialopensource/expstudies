context("test-day_functions")

test_records <- data.frame(key = c("A", "B"),
                           start =  c(as.Date("2000-01-01"), as.Date("2001-03-31")),
                           end = c(as.Date("2000-01-03"), as.Date("2001-04-02")),
                           stringsAsFactors = FALSE)

test_that("Day calculations work with/without truncation", {
  expect_equal(all.equal(addDays(test_records), all_days), TRUE)
  expect_equal(all.equal(addDays(test_records, min_date = as.Date("2000-01-02")), lower_trunc_days), TRUE)
  expect_equal(all.equal(addDays(test_records, max_date = as.Date("2000-06-02")), upper_trunc_days), TRUE)
  expect_equal(all.equal(addDays(test_records, min_date = as.Date("2000-01-02"), max_date = as.Date("2000-06-02")),
                         lower_upper_trunc), TRUE)})

#A record with a non-unique key, not allowable input.
record_bad_key <- data.frame(key = rep("A", 2), start = rep(as.Date("2000-01-01"), 2), end = rep(as.Date("2001-02-10"), 2), stringsAsFactors = FALSE)

test_that("Non-unique key returns error", {
  expect_error(addDays(record_bad_key), "Key is not unique") })
