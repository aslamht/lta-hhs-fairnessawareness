# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# render_functions.R ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# R code of the Learning Technology & Analytics Research Group of THUAS
# Copyright 2025 THUAS
# Web Page: http://www.thuas.com
# Contact: Theo Bakker (t.c.bakker@hhs.nl)
# Distribution outside THUAS: Yes
#
# Purpose: Rendering quarto profile
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

render_basic_report <- function(params) {
  quarto::quarto_render(
    input    = "ch-models.qmd",
    execute_params = params,
    as_job   = FALSE,
    profile = "basic-report"
  )
  
  quarto::quarto_render(
    input = "ch-equity.qmd",
    execute_params = params,
    as_job = FALSE,
    profile = "basic-report"
  )
  
  quarto::quarto_render(execute_params = params,
                        as_job = FALSE,
                        profile = "basic-report")
}

render_advanced_report <- function(params) {
  quarto::quarto_render(execute_params = params,
                        as_job = FALSE,
                        profile = "advanced-report")
}

if (sys.nframe() == 0){
  
  params <- list(sp = "ES-ES", sp_form = "VT")
  
  render_basic_report(params)
  
}

