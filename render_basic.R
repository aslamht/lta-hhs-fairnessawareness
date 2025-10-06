# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# quarto-render-basic-report.R ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# R code of the Learning Technology & Analytics Research Group of THUAS
# Copyright 2025 THUAS
# Web Page: http://www.thuas.com
# Contact: Theo Bakker (t.c.bakker@hhs.nl)
# Distribution outside THUAS: Yes
#
# Purpose: Rendering quarto profile: basic-report
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

invisible(withr::with_envvar(new = c("QUARTO_PROFILE" = "basic-report"), {
  quarto::quarto_render(input    = "ch-models.qmd",
                        execute_params = execute_params_list,
                        as_job   = FALSE)
  quarto::quarto_render(input = "ch-equity.qmd",
                        execute_params = execute_params_list,
                        as_job = FALSE)
  
  quarto::quarto_render(execute_params = execute_params_list, as_job = FALSE)
}))
