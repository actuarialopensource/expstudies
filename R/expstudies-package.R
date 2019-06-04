#' expstudies: package for life experience data
#'
#' Creation of an exposure table with rows for policy-intervals from a table
#' with a unique policy number key and beginning and ending dates for each policy.
#' Methods for assigning supplemental data containing dates and policy numbers
#' to the corresponding interval from the created exposures table.
#'
#' @section expstudies functions:
#' \itemize{
#'   \item addExposures - Creation of an exposure table with either policy years or policy months.
#'   \item addStart - Allocate transactions to intervals.
#' }
#'
#'
#' @importFrom magrittr "%>%"
#' @importFrom lubridate "%m+%"
#'
#' @docType package
#' @name expstudies

## usethis namespace: start
#' @useDynLib expstudies, .registration = TRUE
## usethis namespace: end

## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
NULL

utils::globalVariables(c("start", "end", "key", "dummy", "yrs_past_start", "start_int",
                         "end_int", "duration", "exposure", "policy_month", "trans_date",
                         "year_increment", "max_year", "min_year", "years"))
