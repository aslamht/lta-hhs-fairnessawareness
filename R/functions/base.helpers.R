# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# base.helpers.R ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# R code of the Learning Technology & Analytics Research Group of THUAS
# Copyright 2025 THUAS
# Web Page: http://www.thuas.com
# Contact: Theo Bakker (t.c.bakker@hhs.nl)
# Distribution outside THUAS: Yes
#
# Purpose: Necessary functions to replace the original ltabase functions
#
# Dependencies: None
#
# Datasets: None
#
# Remarks:
# 1) None.
# 2) ___
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# . ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 1. DEBUGGING FUNCTIONS ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Function to set debug options
set_icecream_options <- function() {
  options(
    icecream.enabled = FALSE,
    icecream.peeking.function = head,
    icecream.max.lines = 5,
    icecream.prefix = "🍦",
    icecream.always.include.context = FALSE
  )
}

# . ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 2. ADDITIONAL FUNCTIONS ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


load_datasets <- function(message = FALSE) {
  datasets <- list(
    # df_documentation = get_df_documentation(),
    df_studyprogrammes = rio::import("R/data/studyprogrammes.rda", trust = TRUE)#,
    # df_institutions = get_df_institutions(),
    # df_sectors = get_df_sectors(),
    # df_studytypes = get_df_studytypes(),
    # df_studyforms = get_df_studyforms()
  )
  set_variables_from_list(datasets)
  if (message == TRUE) {
    cli::cli_alert(c(
      "The following datasets have been loaded: \n",
      "\n",
      paste0(names(datasets), collapse = "\n")
    ))
  }
}  

set_variables_from_list <- function(list) {
  list2env(stats::setNames(list, nm = names(list)), envir = .GlobalEnv)
}

