#' Remove Transactions Not in Exposures.
#'
#' This function first converts the output of makeExposures back into a single row for each unique policy key
#' with a start and end date. This is joined to the corresponding key column for the transaction
#' and dates falling outside the exposure interval are filtered out of the transaction.
#'
#' @param exposures Output from addExposures(records).
#' @param trans Information we wish to filter to be within the exposure intervals.
#' @return A modified version of trans where observations have matching policy keys and exposure intervals in
#' exposures
filter_trans <- function(exposures, trans){
  records <- exposures %>% dplyr::group_by(key) %>%
    dplyr::summarise(start = min(start_int), end = max(end_int))
  filtered_trans <- dplyr::inner_join(records, trans, by = "key") %>%
    dplyr::filter(trans_date >= start, trans_date <= end) %>%
    dplyr::select(-c(start, end))
}

#' Map Transaction Rows to Exposure Rows
#'
#' This function takes in exposures and transactions and returns all transactions with a matching "key"
#' and "trans_date" within an exposure interval and attaches the start date of the corresponding
#' exposure interval. This is useful for grouping by start date and key, aggregating, and joining
#' to the exposure rows. In this way premium pattern analysis can be performed.
#'
#' @param exposures Output from addExposures(records).
#' @param trans Information we wish to assign to exposure intervals.
#' @return Modified transaction records that corresponding to an exposure interval, the interval start date
#' is included.
#' @export
addStart <- function(exposures, trans){
  f_trans <- filter_trans(exposures, trans)
  f_trans <- f_trans %>% arrange(key, trans_date)

  exposures <- exposures %>% arrange(key, start_int)

  start_int <- findStart(exposures$key, exposures$start_int, exposures$end_int,
                         f_trans$key, f_trans$trans_date)

  f_trans %>% mutate(start_int = start_int) %>% select(start_int, everything())
}

