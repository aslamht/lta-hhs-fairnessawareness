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
  withr::with_envvar(new = c("QUARTO_PROFILE" = "basic-report"), {
    quarto::quarto_render(input    = "ch-models.qmd",
                          execute_params = params,
                          as_job   = FALSE)
    quarto::quarto_render(input = "ch-equity.qmd",
                          execute_params = params,
                          as_job = FALSE)
    
    quarto::quarto_render(execute_params = params, as_job = FALSE)
  })
}

render_advanced_report <- function(params) {
  withr::with_envvar(new = c("QUARTO_PROFILE" = "advanced-report"), {
    quarto::quarto_render(execute_params = params, as_job = FALSE)
  })
}


render_advanced_report(list(sp = "ES-ES", sp_form = "VT"))
