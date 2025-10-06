# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# quarto-render-advanced-report.R ####
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# R code of the Learning Technology & Analytics Research Group of THUAS
# Copyright 2025 THUAS
# Web Page: http://www.thuas.com
# Contact: Theo Bakker (t.c.bakker@hhs.nl)
# Distribution outside THUAS: Yes
#
# Purpose: Rendering quarto profile: advanced-report
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

invisible(
# Render an advanced report
withr::with_envvar(new = c("QUARTO_PROFILE" = "advanced-report"), {
  quarto::quarto_render(execute_params = execute_params_list,
                        as_job = FALSE)
})
)
