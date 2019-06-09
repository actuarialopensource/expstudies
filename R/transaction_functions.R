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
#' @examples
#' addStart(trans, exposures)
#' @export
addStart <- function(trans, exposures){
  trans <- trans %>% dplyr::arrange(key, trans_date)
  exposures <- exposures %>% dplyr::arrange(key, start_int)
  start_int <- findStart(exposures$key, exposures$start_int, exposures$end_int,
                          trans$key, trans$trans_date)
  trans %>%
    dplyr::mutate(start_int = start_int) %>%
    dplyr::filter(!is.na(start_int)) %>%
    dplyr::select(start_int, dplyr::everything())
}

