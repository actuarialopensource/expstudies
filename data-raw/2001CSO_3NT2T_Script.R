setwd("~/GitHub/expstudies/data-raw/2001CSO_3NT_2Tob_ANB")

library(tidyverse)
library(readxl)
library(stringr)
#You need to set your working directory to the file with all of the excel files
file.list <- list.files(path = ".", pattern='*.xls')

#Initialize lists with elements for each select/ultimate table in each excel file
all_select <- vector(mode="list", length=length(file.list))
all_ultimate <- vector(mode="list", length=length(file.list))

#Iterate through files
for(i in seq_along(file.list)){
  #Read in table name
  table_name <- read_excel(path = file.list[i], col_names = FALSE, range = "B1") %>% unlist()
  #Extract gender from table name
  gender <- case_when(
    str_detect(table_name, "Male") ~ "Male",
    str_detect(table_name, "Female") ~ "Female"
  )
  #Extract risk class from table name
  prefix <- case_when(
    str_detect(table_name, "Super") ~ "SuperPref",
    str_detect(table_name, "Preferred") ~ "Preferred",
    str_detect(table_name, "Residual") ~ "Residual"
  )
  tobacco <- case_when(
    str_detect(table_name, "Nonsmoker") ~ "Nonsmoker",
    str_detect(table_name, "Smoker") ~ "Smoker"
  )
  risk <- paste(prefix, tobacco, sep = " ")

  #Table identifier from SOA
  table <- substr(file.list[i], 1, nchar(file.list[i])-5)


  all_select[[i]] <- read_excel(path = file.list[i], col_names = TRUE, range = "A24:Z124") %>%
    rename("issue_age" = "Row\\Column") %>%
    gather("duration", "q_sel", -issue_age) %>%
    mutate(table = table, gender = gender, risk = risk) %>%
    select(table, gender, risk, everything())

  all_ultimate[[i]] <- read_excel(path = file.list[i], col_names = TRUE, range = "A138:B243") %>%
    rename("attained_age" = "Row\\Column", "q_ult" = "1") %>%
    mutate(table = table, gender = gender, risk = risk) %>%
    select(table, gender, risk, everything())
}

#Collapse the select mortalities into a single data frame
CSO2001ANB_3NT2T_Select <- bind_rows(all_select) %>%
  mutate(issue_age = as.integer(issue_age), duration = as.integer(duration), q_sel = as.double(q_sel)) %>%
  arrange(table, issue_age, duration)

#Collapse the ultimate mortalities into a single data frame
CSO2001ANB_3NT2T_Ultimate <- bind_rows(all_ultimate) %>%
  mutate(attained_age = as.integer(attained_age), q_ult = as.double(q_ult))


example_policy <- tibble(issue_age = 43, duration = 1:10, attained_age = 43:52,
       gender = "Male", risk = "Preferred Nonsmoker")

example_policy %>% left_join(CSO2001ANB_3NT2T_Select)
example_policy %>% left_join(CSO2001ANB_3NT2T_Ultimate)

usethis::use_data(CSO2001ANB_3NT2T_Select)
usethis::use_data(CSO2001ANB_3NT2T_Ultimate)
