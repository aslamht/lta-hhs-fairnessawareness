# Select the best model
source("R/functions/report.helpers.R")

current_sp <- get_current_sp(params$sp, params$sp_form)

determin_fitted_model <- function(current_sp) {
  # Load last_fits
  fittedmodels_outputpath <- get_model_outputpath(mode = "last-fits", current_sp)
  last_fits <- readRDS(fittedmodels_outputpath)
  
  # Load df_model_results
  modelresults_outputpath <- get_model_outputpath(mode = "modelresults", current_sp)
  df_model_results <- readRDS(modelresults_outputpath)
  
  
  best_model <- df_model_results$model[df_model_results$best == TRUE]
  last_fit    <- last_fits[[best_model]]
  
  fitted_model <- last_fit |>
    tune::extract_fit_parsnip()
  
  # If the model is logistic regression, check that the coefficients of the model are numerical
  if (best_model == "Logistic Regression") {
    
    coefs <- tidy(fitted_model)$estimate
    
    # Check that the coefficients are numerical
    if (!is.numeric(coefs)) {
      stop("De geëxtraheerde coëfficiënten zijn niet numeriek.")
    }
    
  }
  
  return(fitted_model)
}



