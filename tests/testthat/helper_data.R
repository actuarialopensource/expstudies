#Expected data frame from addExposures(record_start, type = 'PY')
good_PY <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A"),
  duration = c(1, 2),
  start_int = c(as.Date("2000-01-01"), as.Date("2001-01-01")),
  end_int = c(as.Date("2000-12-31"), as.Date("2001-02-10")),
  exposure = c(366, 41)/365.25)

#Expected data frame from addExposures(record_start, type = 'PM')
good_PM <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(record_mid, type = 'PYCY')
good_PYCY_mid <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A"),
  duration = c(1, 1, 2),
  start_int = c(as.Date("2000-06-15"), as.Date("2001-01-01"), as.Date("2001-06-15")),
  end_int = c(as.Date("2000-12-31"), as.Date("2001-06-14"), as.Date("2001-07-25")),
  exposure = c(200, 165, 41)/365.25)
#Expected data frame from addExposures(record_start, type = 'PYCY')
good_PYCY_start <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A"),
  duration = c(1, 2),
  start_int = c(as.Date("2000-01-01"), as.Date("2001-01-01")),
  end_int = c(as.Date("2000-12-31"), as.Date("2001-02-10")),
  exposure = c(366, 41)/365.25)

#Expected data frame from addExposures(record_mid, type = "PYCM")
good_PYCM_mid <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2),
  start_int = c(as.Date("2000-06-15"), as.Date("2000-07-01"), as.Date("2000-08-01"),
                as.Date("2000-09-01"), as.Date("2000-10-01"), as.Date("2000-11-01"),
                as.Date("2000-12-01"), as.Date("2001-01-01"), as.Date("2001-02-01"),
                as.Date("2001-03-01"), as.Date("2001-04-01"), as.Date("2001-05-01"),
                as.Date("2001-06-01"), as.Date("2001-06-15"), as.Date("2001-07-01")),
  end_int = c(as.Date("2000-06-30"), as.Date("2000-07-31"), as.Date("2000-08-31"),
              as.Date("2000-09-30"), as.Date("2000-10-31"), as.Date("2000-11-30"),
              as.Date("2000-12-31"), as.Date("2001-01-31"), as.Date("2001-02-28"),
              as.Date("2001-03-31"), as.Date("2001-04-30"), as.Date("2001-05-31"),
              as.Date("2001-06-14"), as.Date("2001-06-30"), as.Date("2001-07-25")),
  exposure = c(16, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 14, 16, 25)/365.25)
#Expected data frame from addExposures(record_start, type = "PYCM")
good_PYCM_start <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(record_mid, type = "PMCY")
good_PMCY_mid <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-06-15"), as.Date("2000-07-15"), as.Date("2000-08-15"),
                as.Date("2000-09-15"), as.Date("2000-10-15"), as.Date("2000-11-15"),
                as.Date("2000-12-15"), as.Date("2001-01-01"), as.Date("2001-01-15"),
                as.Date("2001-02-15"), as.Date("2001-03-15"), as.Date("2001-04-15"),
                as.Date("2001-05-15"), as.Date("2001-06-15"), as.Date("2001-07-15")),
  end_int = c(as.Date("2000-07-14"), as.Date("2000-08-14"), as.Date("2000-09-14"),
              as.Date("2000-10-14"), as.Date("2000-11-14"), as.Date("2000-12-14"),
              as.Date("2000-12-31"), as.Date("2001-01-14"), as.Date("2001-02-14"),
              as.Date("2001-03-14"), as.Date("2001-04-14"), as.Date("2001-05-14"),
              as.Date("2001-06-14"), as.Date("2001-07-14"), as.Date("2001-07-25")),
  exposure = c(30, 31, 31, 30, 31, 30, 17, 14, 31, 28, 31, 30, 31, 30, 11)/365.25)
#Expected data frame from addExposures(record_start, type = "PMCY")
good_PMCY_start <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(record_mid, type = "PMCM")
good_PMCM_mid <- data.frame(stringsAsFactors = FALSE,
  key = rep("A", 27),
  duration = c(rep(1, 24), c(2, 2, 2)),
  policy_month = as.integer(c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7,
                              8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 1, 1, 2)),
  start_int = c(as.Date("2000-06-15"), as.Date("2000-07-01"), as.Date("2000-07-15"),
                as.Date("2000-08-01"), as.Date("2000-08-15"), as.Date("2000-09-01"),
                as.Date("2000-09-15"), as.Date("2000-10-01"), as.Date("2000-10-15"),
                as.Date("2000-11-01"), as.Date("2000-11-15"), as.Date("2000-12-01"),
                as.Date("2000-12-15"), as.Date("2001-01-01"), as.Date("2001-01-15"),
                as.Date("2001-02-01"), as.Date("2001-02-15"), as.Date("2001-03-01"),
                as.Date("2001-03-15"), as.Date("2001-04-01"), as.Date("2001-04-15"),
                as.Date("2001-05-01"), as.Date("2001-05-15"), as.Date("2001-06-01"),
                as.Date("2001-06-15"), as.Date("2001-07-01"), as.Date("2001-07-15")),
  end_int = c(as.Date("2000-06-30"), as.Date("2000-07-14"), as.Date("2000-07-31"),
              as.Date("2000-08-14"), as.Date("2000-08-31"), as.Date("2000-09-14"),
              as.Date("2000-09-30"), as.Date("2000-10-14"), as.Date("2000-10-31"),
              as.Date("2000-11-14"), as.Date("2000-11-30"), as.Date("2000-12-14"),
              as.Date("2000-12-31"), as.Date("2001-01-14"), as.Date("2001-01-31"),
              as.Date("2001-02-14"), as.Date("2001-02-28"), as.Date("2001-03-14"),
              as.Date("2001-03-31"), as.Date("2001-04-14"), as.Date("2001-04-30"),
              as.Date("2001-05-14"), as.Date("2001-05-31"), as.Date("2001-06-14"),
              as.Date("2001-06-30"), as.Date("2001-07-14"), as.Date("2001-07-25")),
  exposure = c(16, 14, 17, 14, 17, 14, 16, 14, 17, 14, 16, 14, 17, 14,
               17, 14, 14, 14, 17, 14, 16, 14, 17, 14, 16, 14, 11)/365.25)
#Expected data frame from addExposures(record_start, type = "PMCM")
good_PMCM_start <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(old_record_mid, type = "PY", lower_year = 2000)
good_old_PY <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A"),
  duration = c(201, 202),
  start_int = c(as.Date("2000-06-15"), as.Date("2001-06-15")),
  end_int = c(as.Date("2001-06-14"), as.Date("2001-07-25")),
  exposure = c(365, 41)/365.25)

#Expected data frame from addExposures(old_record_start, type = "PM", lower_year = 2000)
good_old_PM <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 202, 202),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(old_record_mid, type = "PYCY", lower_year = 2000)
good_old_PYCY <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A"),
  duration = c(200, 201, 201, 202),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-06-15"), as.Date("2001-01-01"), as.Date("2001-06-15")),
  end_int = c(as.Date("2000-06-14"), as.Date("2000-12-31"), as.Date("2001-06-14"), as.Date("2001-07-25")),
  exposure = c(166, 200, 165, 41)/365.25)

#Expected data frame from addExposures(old_record_start, type = "PYCM")
good_old_PYCM <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 202, 202),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(old_record_start, type = "PMCY")
good_old_PMCY <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 202, 202),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

#Expected data frame from addExposures(old_record_start, type = "PMCM")
good_old_PMCM <- data.frame(stringsAsFactors = FALSE,
  key = c("A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"),
  duration = c(201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 202, 202),
  policy_month = as.integer(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2)),
  start_int = c(as.Date("2000-01-01"), as.Date("2000-02-01"), as.Date("2000-03-01"),
                as.Date("2000-04-01"), as.Date("2000-05-01"), as.Date("2000-06-01"),
                as.Date("2000-07-01"), as.Date("2000-08-01"), as.Date("2000-09-01"),
                as.Date("2000-10-01"), as.Date("2000-11-01"), as.Date("2000-12-01"),
                as.Date("2001-01-01"), as.Date("2001-02-01")),
  end_int = c(as.Date("2000-01-31"), as.Date("2000-02-29"), as.Date("2000-03-31"),
              as.Date("2000-04-30"), as.Date("2000-05-31"), as.Date("2000-06-30"),
              as.Date("2000-07-31"), as.Date("2000-08-31"), as.Date("2000-09-30"),
              as.Date("2000-10-31"), as.Date("2000-11-30"), as.Date("2000-12-31"),
              as.Date("2001-01-31"), as.Date("2001-02-10")),
  exposure = c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 10)/365.25)

####################################################################################################

all_days <- data.frame(
  key = c("A", "A", "A", "B", "B", "B"),
  date = c(as.Date("2000-01-01"), as.Date("2000-01-02"), as.Date("2000-01-03"),
           as.Date("2001-03-31"), as.Date("2001-04-01"), as.Date("2001-04-02")),
  stringsAsFactors = FALSE
)

lower_trunc_days <- data.frame(
  key = c("A", "A", "B", "B", "B"),
  date = c(as.Date("2000-01-02"), as.Date("2000-01-03"),
           as.Date("2001-03-31"), as.Date("2001-04-01"), as.Date("2001-04-02")),
  stringsAsFactors = FALSE
)

upper_trunc_days <- data.frame(
  key = c("A", "A", "A"),
  date = c(as.Date("2000-01-01"), as.Date("2000-01-02"), as.Date("2000-01-03")),
  stringsAsFactors = FALSE
)

lower_upper_trunc <- data.frame(
  key = c("A", "A"),
  date = c(as.Date("2000-01-02"), as.Date("2000-01-03")),
  stringsAsFactors = FALSE
)



