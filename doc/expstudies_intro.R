## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup---------------------------------------------------------------
library(expstudies)

## ----message = FALSE-----------------------------------------------------
library(dplyr)
library(magrittr)

## ---- include=FALSE------------------------------------------------------
#We load the "pander" package to create our tables.
library(pander)

## ---- results = "hide"---------------------------------------------------
records

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
exposures_mod <- exposures %>% group_by(key) %>% mutate(exposure_mod = if_else(duration == max(duration), 1, exposure), death_cnt = if_else(duration == max(duration), 1, 0)) %>% ungroup()

tail(exposures_mod, 4)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(tail(exposures_mod, 4))

## ---- results = "hide"---------------------------------------------------
exposures_mod %>% group_by(duration) %>% summarise(q = sum(death_cnt)/sum(exposure_mod))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(exposures_mod %>% group_by(duration) %>% summarise(q = sum(death_cnt)/sum(exposure_mod)))

## ---- results = "hide"---------------------------------------------------
exposures_mod <- exposures_mod %>% inner_join(select(records, key, issue_age, gender), by = "key")
head(exposures_mod)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(exposures_mod))

## ---- results = "hide"---------------------------------------------------
exposures_mod %>% mutate(attained_age = issue_age + duration - 1) %>% group_by(attained_age, gender) %>% summarise(q = sum(death_cnt)/sum(exposure_mod)) %>% tail()

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(exposures_mod %>% mutate(attained_age = issue_age + duration - 1) %>% group_by(attained_age, gender) %>% summarise(q = sum(death_cnt)/sum(exposure_mod)) %>% tail())

## ---- results = "hide"---------------------------------------------------
head(trans)

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(head(trans))

## ---- results = "hide"---------------------------------------------------
trans_with_interval <- addStart(exposures_PM, trans)
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

