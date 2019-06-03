context("test-transaction_functions")

#The top row has no matching date interval in good_PM, the second row has a good date and key,
#the third has a bad key
trans_test <- data.frame(key = c("A", "A", "B"),
                         trans_date = c(as.Date("1999-01-01"), as.Date("2000-10-15"), as.Date("2000-10-15")),
                         stringsAsFactors = FALSE)
#Expoected outcome of addStart(good_PM, trans_test)
good_trans_with_start <- data.frame(start_int = as.Date("2000-10-01"),
                                    key = "A",
                                    trans_date = as.Date("2000-10-15"), stringsAsFactors = FALSE)

test_that("Transaction allocation works", {
  expect_equal(all.equal(addStart(trans_test, good_PM), good_trans_with_start), TRUE) })

bad_exposures <- good_PY
bad_exposures[1,4] <- as.Date("2000-09-01")
test_that("Error is thrown for modified exposure frame where f_trans has no match", {
  expect_error(addStart(trans_test, bad_exposures)) })

