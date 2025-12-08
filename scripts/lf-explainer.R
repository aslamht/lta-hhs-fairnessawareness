library(DALEXtra)

# Select the best model
source("R/functions/report.helpers.R")

current_sp <- get_current_sp(params$sp, params$sp_form)

# Load last_fits
fittedmodels_outputpath <- get_model_outputpath(mode = "last-fits", current_sp)
last_fits <- readRDS(fittedmodels_outputpath)

# Load df_model_results
modelresults_outputpath <- get_model_outputpath(mode = "modelresults", current_sp)
df_model_results <- readRDS(modelresults_outputpath)


best_model <- df_model_results$model[df_model_results$best == TRUE]
last_fit    <- last_fits[[best_model]]

data_outputpath <- get_model_outputpath(mode = "data", current_sp)

df_levels <- get_df_levels()
levels <- get_levels(df_levels)

df_sp_enrollments <- rio::import(data_outputpath, trust = TRUE) |>
  mutate(across(all_of(names(levels)), ~ factor(.x,
                                                levels = levels[[cur_column()]]
  ))) |>
  mutate(Retentie = as.numeric(Retentie) - 1)

# Extract the fitted model
fitted_model <- last_fit |>
  tune::extract_fit_parsnip()

# Extract the workflow
workflow <- last_fit |>
  tune::extract_workflow()

# Create an explainer
explain_lf <- DALEX::explain(model = workflow,
                             data = df_sp_enrollments |> select(-Retentie),
                             y = df_sp_enrollments$Retentie,
                             colorize = TRUE,
                             verbose = TRUE,
                             label = best_model)

if (is.null(explain_lf$y_hat) || is.null(explain_lf$residuals)) {
  cli::cli_alert_danger(glue::glue(
    "The explainer does not contain the correct results. ",
    "Check the installation of model packages: ",
    "{glue::glue_collapse(explain_lf$model_info$package, sep = ', ')}"
  ))
  stop("Solve this problem first")
}
