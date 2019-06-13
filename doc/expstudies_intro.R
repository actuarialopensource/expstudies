## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message = FALSE-----------------------------------------------------
library(expstudies)
library(dplyr)
library(magrittr)

## ---- include=FALSE------------------------------------------------------
#We load the "pander" package to create our tables.
library(pander)

## ---- results = "hide"---------------------------------------------------
expstudies::records

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(records)

## ---- results = "hide"---------------------------------------------------
exposures <- addExposures(records)
head(exposures)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures))

## ---- results = "hide"---------------------------------------------------
exposures_PM <- addExposures(records, type = "PM")
head(exposures_PM)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_PM))

## ---- results = "hide"---------------------------------------------------
exposures_PYCY <- addExposures(records, type = "PYCY")
head(exposures_PYCY)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_PYCY))

## ---- results = "hide"---------------------------------------------------
exposures_PYCM <- addExposures(records, type = "PYCM")
head(exposures_PYCM, n = 15)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_PYCM, n = 15))

## ---- results = "hide"---------------------------------------------------
exposures_PYCM <- addExposures(records, type = "PMCY")
head(exposures_PYCM, n = 11)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_PYCM, n = 11))

## ---- results = "hide"---------------------------------------------------
exposures_PMCM <- addExposures(records, type = "PMCM")
head(exposures_PMCM)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_PMCM))

## ---- results = "hide"---------------------------------------------------
exposures_PM_2019 <- addExposures(records, type = "PM", lower_year = 2019)
exposures_PM_2019

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(exposures_PM_2019)

## ---- results = "hide"---------------------------------------------------
exposures_PYCM_2019 <- addExposures(records, type = "PYCM", lower_year = 2019)
exposures_PYCM_2019

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(exposures_PYCM_2019)

## ---- results = "hide"---------------------------------------------------
exposures_mod <- exposures %>% inner_join(select(records, key, issue_age, gender), by = "key") %>%
  mutate(attained_age = issue_age + duration - 1)
head(exposures_mod)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_mod))

## ---- results = "hide"---------------------------------------------------
exposures_mort <- exposures_mod %>% group_by(key) %>% mutate(exposure_mod = if_else(duration == max(duration), 1, exposure), death_cnt = if_else(duration == max(duration), 1, 0)) %>% ungroup()

tail(exposures_mort, 4)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(tail(exposures_mort, 4))

## ---- results = "hide"---------------------------------------------------
duration_rates <- exposures_mort %>% group_by(duration) %>% summarise(q = sum(death_cnt)/sum(exposure_mod))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(exposures_mort %>% group_by(duration) %>% summarise(q = sum(death_cnt)/sum(exposure_mod)))

## ---- results = "hide"---------------------------------------------------
attained_age_gender_rates <- exposures_mort %>% mutate(attained_age = issue_age + duration - 1) %>% group_by(attained_age, gender) %>% summarise(q = sum(death_cnt)/sum(exposure_mod))
tail(attained_age_gender_rates)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(tail(attained_age_gender_rates))

## ------------------------------------------------------------------------
summary(expstudies::mortality_tables)

## ---- results = "hide"---------------------------------------------------
head(mortality_tables$AM92$AM92_Ultimate)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(mortality_tables$AM92$AM92_Ultimate))

## ---- results = "hide"---------------------------------------------------
head(left_join(exposures_mort, mortality_tables$AM92$AM92_Ultimate, by = "attained_age"))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(left_join(exposures_mort, select(mortality_tables$AM92$AM92_Ultimate, -table), by = "attained_age")))

## ---- results = "hide"---------------------------------------------------
head(trans)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(trans))

## ---- results = "hide"---------------------------------------------------
trans_with_interval <- addStart(trans, exposures_PM)
head(trans_with_interval)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(trans_with_interval))

## ---- results = "hide"---------------------------------------------------
trans_to_join <- trans_with_interval %>% group_by(start_int, key) %>% summarise(premium = sum(amt))
head(trans_to_join)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(trans_to_join))

## ---- results = "hide"---------------------------------------------------
premium_study <- exposures_PM %>% left_join(trans_to_join, by = c("key", "start_int"))
head(premium_study, 10)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(premium_study, 10))

## ---- results = "hide"---------------------------------------------------
premium_study <- premium_study %>% mutate(premium = if_else(is.na(premium), 0, premium))
head(premium_study, 10)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(premium_study, 10))

## ---- results = "hide"---------------------------------------------------
premium_study %>% filter(policy_month %in% c(1,2)) %>% group_by(policy_month) %>% summarise(avg_premium = mean(premium))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(premium_study %>% filter(policy_month %in% c(1,2)) %>% group_by(policy_month) %>% summarise(avg_premium = mean(premium)))

