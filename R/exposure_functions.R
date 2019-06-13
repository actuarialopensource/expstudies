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
#' @keywords internal
#'
makeRange <- function(duration){
  join_by = data.frame(join_by = 0:max(duration), dummy = TRUE)
  yrs_past_start = data.frame(yrs_past_start = 0:max(duration), dummy = TRUE)

  dplyr::inner_join(join_by, yrs_past_start, by = "dummy") %>%
    dplyr::filter(join_by >= yrs_past_start) %>%
    dplyr::select(-dummy)
}


#' Create an exposure data frame
#'
#' This function takes a records file with unique policy identifiers in the column "key",
#' exposure start dates in column "start" and exposure end dates in column "end".
#' The output is a data frame with exposures and durations for time intervals.
#'
#' @param records File containing a unique policy key with start and end dates.
#' @param type Creates policy year rows for the default type = "PY".
#' Creates policy month rows for type = "PM".
#' @param lower_year A lower year for truncation to reduce calculation time and output size.
#' @param upper_year An upper year for truncation to reduce calculation time and output size.
#' @return A data frame with multiple rows for each unique policy key. Each row represents a
#' policy interval.
#' @examples
#' addExposures(records)
#' @export
addExposures <- function(records, type = "PY", lower_year = NULL, upper_year = NULL){
  #Require a unique key.
  if(anyDuplicated(records$key)){
    stop('Key is not unique')
  }

  possible_types <- c("PY", "PM", "PYCY", "PYCM", "PMCY", "PMCM")
  if (!(type %in% possible_types)){
    stop('invalid type argument')
  }

  #Increment up the start interval to the year prior lower_year to reduce calculation size.
  #Filtered later for an exact lower truncation. key_and_year increment is book-keeping
  if(!is.null(lower_year)){
    if(lower_year%%1 != 0) stop("lower_year must be an integer")
    records <- records %>%
      dplyr::mutate(year_increment = dplyr::if_else(lower_year - lubridate::year(start) >= 2,
                                                    lower_year - lubridate::year(start) - 1, 0),
                    start = start %m+% lubridate::years(year_increment))
    key_and_year_increment <- records %>% dplyr::select(key, year_increment)
  }

  #Increment down the final interval to be within upper year.
  if(!is.null(upper_year)){
    if(upper_year%%1 != 0) stop("upper_year must be an integer")
    #Bring to end of last full policy year for types PY, PM, otherwise to end of upper_year
    records <- records %>%
      dplyr::mutate(end = dplyr::case_when(
      lubridate::year(end) <= upper_year ~ end,
      type %in% c("PY", "PM") ~ end %m+% lubridate::years(-(lubridate::year(end) - upper_year)),
      TRUE ~ lubridate::ceiling_date(end %m+% lubridate::years(-(lubridate::year(end) - upper_year)), unit = "year") - 1))
  }

  #Load only the columns for the key, start, and end. Filter out start dates past end dates.
  mod_records <- records %>% dplyr::select(key, start, end) %>% dplyr::filter(start <= end)
  bad_count <- nrow(records) - nrow(mod_records)

  if(bad_count == nrow(records)){
    stop('All records have end dates before start dates, no exposures')
  }

  #We add a row for each year. Extra rows may be added, are filtered later.
  addPY <- function(){
    mod_records <- mod_records %>%
      dplyr::mutate(max_d = lubridate::year(end) - lubridate::year(start))
    mod_records %>%
      dplyr::inner_join(makeRange(mod_records$max_d), by = c("max_d" = "join_by")) %>%
      dplyr::mutate(start_int = start %m+% lubridate::years(yrs_past_start)) %>%
      dplyr::filter(start_int <= end)
  }
  #I called addPY before addPM but both create start_int. It works but is it elegant?
  #We first call addPY and then add 12 months to each year. Extra rows may be added, are filtered later.
  addPM <- function(){
    mod_exposures <- addPY() %>% dplyr::mutate(dummy = TRUE)
    through_12 <- data.frame(dummy = TRUE, policy_month = 1:12)
    mod_exposures %>% dplyr::inner_join(through_12, by = "dummy") %>%
      dplyr::select(-dummy) %>%
      dplyr::mutate(start_int = start %m+% lubridate::years(yrs_past_start) %m+% months(policy_month-1)) %>%
      dplyr::filter(start_int <= end)
  }

  #Add in the end intervals, calculate exposures, include durations
  addDetails <- function(exposure_base){
    exposure_base %>% dplyr::group_by(key) %>%
      dplyr::mutate(end_int = dplyr::lead(start_int) - 1, end_int = dplyr::if_else(is.na(end_int), end, end_int),
                    exposure = as.integer(end_int - start_int + 1)/365.25,
                    duration = yrs_past_start + 1) %>% dplyr::ungroup()
  }

  #Calculate the interval ends, exposures, and durations
  formatPY <- function(){
    addPY() %>% addDetails() %>%
      dplyr::select(key, duration, start_int, end_int, exposure)
  }

  #Add policy months
  formatPM <- function(){
    addPM() %>% addDetails() %>%
    dplyr::select(key, duration, policy_month, start_int, end_int, exposure)
  }

  #Add policy years, intervals are not split across calendar years allowing for calendar year studies.
  formatPYCY <- function(){
    PY_start <- addPY() %>% dplyr::mutate(PY_start = TRUE)
    CY_start <- addPY() %>% dplyr::mutate(start_int = lubridate::ceiling_date(start_int, unit = "year"), PY_start = FALSE) %>%
      dplyr::filter(start_int <= end)
    PYandCY <- rbind(PY_start, CY_start) %>% dplyr::arrange(key, start_int, PY_start)

    #The dplyr::filter will remove duplicate values where policy years collide with calendar years.
    #See tests/testthat/helper_data.R for an example of the desired behavior in this case.
    PYandCY %>% addDetails() %>% dplyr::filter(exposure > 0) %>%
      dplyr::select(key, duration, start_int, end_int, exposure)
  }

  #Add policy years, intervals are not split across calendar months allowing for calendar month studies.
  formatPYCM <- function(){
    PY_start <- addPY() %>% dplyr::mutate(PY_start = TRUE)
    CM_start <- addPM() %>% dplyr::mutate(start_int = lubridate::ceiling_date(start_int, unit = "month"), PY_start = FALSE) %>%
      dplyr::filter(start_int <= end) %>% dplyr::select(-policy_month)
    PYandCM <- rbind(PY_start, CM_start) %>% dplyr::arrange(key, start_int, PY_start)

    PYandCM %>% addDetails() %>% dplyr::filter(exposure > 0) %>%
      dplyr::select(key, duration, start_int, end_int, exposure)
  }

  #Add policy months, intervals are not split across calendar years allowing for calendar year studies.
  formatPMCY <- function(){
    PM_start <- addPM() %>% dplyr::mutate(PM_start = TRUE)
    CY_start <- addPY() %>%
      dplyr::mutate(start_int = lubridate::ceiling_date(start_int, unit = "year"), PM_start = FALSE, policy_month = NA) %>%
      dplyr::filter(start_int <= end)
    PMandCY <- rbind(PM_start, CY_start) %>% dplyr::arrange(key, start_int, PM_start) %>%
      dplyr::mutate(policy_month = dplyr::if_else(is.na(policy_month), dplyr::lag(policy_month), policy_month))

    PMandCY %>% addDetails() %>% dplyr::filter(exposure > 0) %>%
      dplyr::select(key, duration, policy_month, start_int, end_int, exposure)
  }

  #Add policy months, intervals are not split across calendar months allowing for calendar month studies.
  formatPMCM <- function(){
    PM_start <- addPM() %>% dplyr::mutate(PM_start = TRUE)
    CM_start <- addPM() %>% dplyr::mutate(start_int = lubridate::ceiling_date(start_int, unit = "month"), PM_start = FALSE) %>%
      dplyr::filter(start_int <= end)
    PMandCM <- rbind(PM_start, CM_start) %>% dplyr::arrange(key, start_int, PM_start)
    #Duplicate values remove the PM_start==FALSE record because it is assigned 0 exposure and filtered.
    PMandCM %>% addDetails() %>% dplyr::filter(exposure > 0) %>%
      dplyr::select(key, duration, policy_month, start_int, end_int, exposure)
  }

  if (type == "PY") {
    result <- formatPY()
  } else if (type == "PM") {
    result <- formatPM()
  } else if (type == "PYCY") {
    result <- formatPYCY()
  } else if (type == "PYCM") {
    result <- formatPYCM()
  } else if (type == "PMCY") {
    result <- formatPMCY()
  } else if (type == "PMCM") {
    result <- formatPMCM()
  } else {
    stop('invalid type argument')
  }

  #key_and_year_increment comes back to join on the key and increment the years
  if(!is.null(lower_year)){
    result <- result %>% dplyr::inner_join(key_and_year_increment, by = "key") %>%
      dplyr::mutate(duration = duration + year_increment) %>%
      dplyr::select(-year_increment) %>%
      dplyr::filter(lubridate::year(start_int) >= lower_year)
  }

  result
}


#' Estimate size of exposure data frame
#'
#' This function takes a records file and the same arguments as the addExposures function to
#' estimate the size of the output created. The upper bound is pretty reasonable. The idea with this function
#' is that it enables users to determine if they can reasonably perform an operation on their computer.
#'
#' @param records File containing a unique policy key with start and end dates.
#' @param type Creates policy year rows for the default type = "PY".
#' Creates policy month rows for type = "PM". Many other variations on this.
#' @param lower_year A lower year for truncation to reduce calculation time and output size.
#' @param upper_year An upper year for truncation to reduce calculation time and output size.
#' @return An upper bound for the number of rows used in the calculation of an exposure frame.
#' @examples
#' addExposures(records)
#' @export
expSize <- function(records, type = "PY", lower_year = NULL, upper_year = NULL){

  possible_types <- c("PY", "PM", "PYCY", "PYCM", "PMCY", "PMCM")
  if (!(type %in% possible_types)){
    stop('invalid type argument')
  }

  rows_per_year <- dplyr::case_when(
    type == "PY" ~ 1,
    type == "PM" ~ 12,
    type == "PYCY" ~ 2,
    type == "PYCM" ~ 13,
    type == "PMCY" ~ 13,
    type == "PMCM" ~ 24
  )

  records <- records %>% dplyr::mutate(max_year = lubridate::year(end),
                                min_year = lubridate::year(start))
  #modfy max_year to account for upper_year
  if(!is.null(upper_year)){
    records <- records %>% dplyr::mutate(max_year = ifelse(upper_year < max_year, upper_year, max_year))
  }
  #modify min_year to account for lower_year
  if(!is.null(lower_year)){
    records <- records %>% dplyr::mutate(min_year = ifelse(min_year < lower_year, lower_year - 1, min_year))
  }

  records %>%
    dplyr::filter(max_year >= min_year) %>%
    dplyr::mutate(years = max_year - min_year + 1) %>%
    dplyr::summarise(row_bound = sum(years*rows_per_year)) %>% unlist()
}


