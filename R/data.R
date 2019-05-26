#' Example policy records to demonstrate calculations
#'
#' A dataset containing 2 policyholders (identified by "key") as well as their issue date
#' ("start") their termination date ("end") as well as some additional information.
#' Used to demonstrate calculations.
#'
"records"

#' Example transaction records to demonstrate calculations
#'
#' A dataset containing transactions. Contains fields for the policyholder identifier ("key"),
#' the transaction date ("trans_date") and the amount of the premium paid ("amt").
#' Used to demonstrate calculations.
"trans"

#' Example exposure records to demonstrate calculations
#'
#' A dataset containing the output of addExposures(records).
#' Used to demonstrate calculations.
"exposures"

#' Long format select SOA tables 1076-1085
#'
#' Intended to be left joined to exposure frames.
"CSO2001ANB_3NT2T_Select"

#' Long format ultimate SOA tables 1076-1085
#'
#' Intended to be left joined to exposure frames.
"CSO2001ANB_3NT2T_Ultimate"
