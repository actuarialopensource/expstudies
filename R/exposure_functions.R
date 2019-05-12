#' All Consecutive Number Intervals Starting at 0
#'
#' A vector of whole numbers is used as input, these whole numbers are the number of
#' calendar years between dates from the addExposures function. Outputs is a data frame
#' with two columns, "join_by", and "yrs_past_start". "join_by" is intended to be joined
#' to the input "duration" column so that there will be rows added for each whole
#' number less than or equal to the duration. This is how many rows are created in the
#' addExposures function.
#'
#' @param duration The vector containing whole numbers that will be joined to.
#' @return A data frame that can be joined to the original vector by = c("duration" = "join_by").
makeRange <- function(duration){
  join_by = data.frame(join_by = 0:max(duration), dummy = TRUE)
  yrs_past_start = data.frame(yrs_past_start = 0:max(duration), dummy = TRUE)

  dplyr::inner_join(join_by, yrs_past_start, by = "dummy") %>%
    dplyr::filter(join_by >= yrs_past_start) %>%
    dplyr::select(-dummy)
}

#' Create an Exposure Data Frame
#'
#' This function takes a records file with unique policy identifiers in the column "key",
#' exposure start dates in column "start" and exposure end dates in column "end".
#' The output is a data frame with exposures and durations for time intervals.
#'
#' @param records File containing a unique policy key with start and end dates.
#' @param type Creates policy year rows for the default type = "PY".
#' Creates policy month rows for type = "PM".
#' @return A data frame with multiple rows for each unique policy key. Each row represents a
#' policy interval.
#' @export
addExposures <- function(records, type = "PY"){
  #Require a unique key.
  if(anyDuplicated(records$key)){
    stop('Key is not unique')
  }

  if(!all(records$end-records$start > 0)){
    warning('End dates before start dates exist, will filter out')
  }

  #Load only the columns for the key, start, and end.
  exposures <- records %>%
    dplyr::select(key, start, end) %>%
    dplyr::filter(end >= start)

  #We add a row for each year. Extra rows may be added, are filtered later.
  addPY <- function(){
    mod_exposures <- exposures %>%
      dplyr::mutate(max_d = lubridate::year(end) - lubridate::year(start))
    mod_exposures %>%
      dplyr::inner_join(makeRange(mod_exposures$max_d), by = c("max_d" = "join_by"))
  }

  #We first call addPY and then add 12 months to each year. Extra rows may be added, are filtered later.
  addPM <- function(){
    mod_exposures <- addPY() %>% dplyr::mutate(dummy = TRUE)
    through_12 <- data.frame(dummy = TRUE, policy_month = 1:12)
    mod_exposures %>% dplyr::inner_join(through_12, by = "dummy") %>% dplyr::select(-dummy)
  }

  formatPY <- function(){
    mod_exposures <- addPY()
    mod_exposures <- mod_exposures %>%
      dplyr::mutate(start_int = start %m+% lubridate::years(yrs_past_start)) %>%
      dplyr::filter(start_int <= end) %>%
      dplyr::mutate(end_int = dplyr::if_else(start_int %m+% lubridate::years(1) - lubridate::days(1) < end, start_int %m+% lubridate::years(1) - lubridate::days(1), end),
                    exposure = as.integer(end_int - start_int + 1)/365.25,
                    duration = yrs_past_start + 1)
    mod_exposures %>% dplyr::select(key, duration, start_int, end_int, exposure)
  }

  formatPM <- function(){
    mod_exposures <- addPM()
    mod_exposures <- mod_exposures %>%
      dplyr::mutate(start_int =
                      start  %m+% lubridate::years(yrs_past_start) %m+% months(policy_month-1)) %>%
      dplyr::filter(start_int <= end) %>%
      dplyr::mutate(end_int = dplyr::if_else(start_int %m+% months(1) - 1 < end,
                                      start_int %m+% months(1) - 1, end),
             exposure = as.integer(end_int - start_int + 1)/365.25,
             duration = yrs_past_start + 1)
    mod_exposures %>% dplyr::select(key, duration, policy_month, start_int, end_int, exposure)
  }

  if (type == "PY") {
    return(formatPY())
  } else if (type == "PM") {
    return(formatPM())
  } else {
    stop('Type should be PM or PY')
  }

}
