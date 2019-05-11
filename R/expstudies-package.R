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
#' @docType package
#' @name expstudies

## usethis namespace: start
#' @useDynLib expstudies, .registration = TRUE
## usethis namespace: end

## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
NULL
