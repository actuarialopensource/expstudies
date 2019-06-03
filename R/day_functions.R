#' Create daily exposures for records
#'
#' This function takes a records file and creates a day for each day the policyholder is active
#'
#' @param records File containing a unique policy key with start and end dates.
#' @param min_date Left truncation date.
#' @param max_date Right truncation date.
#' @examples
#' addDays(records)
#' @export
addDays <- function(records, min_date, max_date){
  records_mod <- records %>% dplyr::mutate(start = dplyr::if_else(start < min_date, min_date, start),
                                    end = dplyr::if_else(end > max_date, max_date, end))
  #Filter out values with start dates past end dates, create a days column to assist iteration in makeDays.
  records_mod <- records %>% dplyr::filter(end >= start) %>%
    dplyr::mutate(days = as.integer(end - start + 1))
  #final_size is used to initialize a dataframe of the correct size.
  final_size <- sum(records_mod$days)
  makeDays(as.character(records_mod$key), records_mod$start, records_mod$days, final_size)
}

#' Estimate the size of daily exposures
#'
#' This function takes a records file and creates a day for each day the policyholder is active
#'
#' @param records File containing a unique policy key with start and end dates.
#' @param min_date Left truncation date.
#' @param max_date Right truncation date.
#' @examples
#' addDays(records)
#' @export
addDays <- function(records, min_date, max_date){
  records_mod <- records %>% dplyr::mutate(start = dplyr::if_else(start < min_date, min_date, start),
                                    end = dplyr::if_else(end > max_date, max_date, end))
  #Filter out values with start dates past end dates, create a days column to assist iteration in makeDays.
  records_mod <- records %>% dplyr::filter(end >= start) %>%
    dplyr::mutate(days = as.integer(end - start + 1))
  #final_size is used to initialize a dataframe of the correct size.
  final_size <- sum(records_mod$days)
  makeDays(as.character(records_mod$key), records_mod$start, records_mod$days, final_size)
}
