# Select the best model
source("R/functions/report.helpers.R")

## Create a list of dfPersonas
load_dfpersona <- function(df_sp_enrollments, sensitive_labels) {
  
  get_df_persona_recursive <- function(df_sp_enrollments, variable_list = NULL) {
    # Initialize the result dataframe
    df_results <- NULL
    
    # Initialize the working dataframe
    df_working <- df_sp_enrollments
    
    # Calculate the total number of students
    total <- df_working |> count() |> pull(n)
    
    # Define categorical and numerical variables present in the dataframe
    list_select_categorical <- c(
      sensitive_labels,
      "Studiekeuzeprofiel",
      "APCG",
      "Cijfer_CE_VO_missing",
      "Cijfer_SE_VO_missing",
      "Cijfer_CE_Nederlands_missing",
      "Cijfer_CE_Engels_missing",
      "Cijfer_CE_Wiskunde_missing",
      "Cijfer_CE_Natuurkunde_missing",
      "Dubbele_studie"
    ) |>
      intersect(colnames(df_working))
    
    list_select_numerical <- c(
      "Leeftijd",
      "Aanmelding",
      "Reistijd",
      "Cijfer_CE_VO",
      "Cijfer_SE_VO",
      "Cijfer_CE_Nederlands",
      "Cijfer_CE_Wiskunde",
      "Cijfer_CE_Engels",
      "Cijfer_CE_Natuurkunde",
      "SES_Totaal",
      "SES_Welvaart",
      "SES_Arbeid"
    ) |>
      intersect(colnames(df_working))
    
    # Add "Rangnummer" if the study programme is HDT
    if (current_sp$INS_Opleiding == "HDT") {
      list_select_numerical <- c(list_select_numerical, "Rangnummer") |>
        intersect(colnames(df_working))
    }
    
    if (is.null(variable_list)) {
      # If no variable list is provided, calculate for the entire dataset
      df_results <- df_working |>
        summarise(
          # Categorical variables
          across(
            all_of(list_select_categorical),
            get_most_common_category,
            .names = "{col}"
          ),
          # Numerical variables
          across(
            all_of(list_select_numerical),
            get_median_rounded,
            .names = "{col}"
          ),
          # Other variables
          Collegejaar = median(Collegejaar, na.rm = TRUE),
          ID = NA,
          Subtotaal = n(),
          .groups = "drop"
        ) |>
        mutate(
          Totaal = total,
          Percentage = round(Subtotaal / Totaal, 3),
          Groep = "Alle",
          Categorie = "Alle studenten"
        ) |>
        mutate(Leeftijd = as.integer(round(Leeftijd, 0))) |>
        select(Groep,
               Categorie,
               Totaal,
               Subtotaal,
               Percentage,
               everything())
      
    } else {
      # Loop through each variable in the list
      for (variable in variable_list) {
        # Convert variable to symbol for dynamic grouping
        .variable <- as.name(variable)
        
        # Exclude the grouping variable from the categorical variables
        list_select_categorical <- setdiff(list_select_categorical, variable)
        
        # Check if the current variable exists in the dataframe
        if (!(variable %in% colnames(df_working))) {
          warning(paste(
            "Variable",
            variable,
            "not found in the dataset. Skipping."
          ))
          next
        }
        
        # Summarise data for the current variable
        df_persona <- df_working |>
          group_by(!!.variable) |>
          summarise(
            # Categorical variables
            across(
              all_of(list_select_categorical),
              get_most_common_category,
              .names = "{col}"
            ),
            # Numerical variables
            across(
              all_of(list_select_numerical),
              get_median_rounded,
              .names = "{col}"
            ),
            # Other variables
            Collegejaar = median(Collegejaar, na.rm = TRUE),
            ID = NA,
            Subtotaal = n(),
            .groups = "drop"
          ) |>
          mutate(
            Totaal = total,
            Percentage = round(Subtotaal / Totaal, 3),
            Groep = variable,
            Categorie = !!.variable
          ) |>
          mutate(Leeftijd = as.integer(round(Leeftijd, 0))) |>
          select(Groep,
                 Categorie,
                 Totaal,
                 Subtotaal,
                 Percentage,
                 everything())
        
        # Append to the result dataframe
        df_results <- bind_rows(df_results, df_persona)
        
        # Update the working dataframe for the next iteration
        df_working <- df_working |>
          filter(!!.variable == get_most_common_category(df_working[[variable]]))
      }
    }
    
    df_results
  }
  
  df_persona_list <- list()
  
  ## Walk over the variables
  df_persona_list <- purrr::map(sensitive_labels,
                                ~ get_df_persona_recursive(df_sp_enrollments, .x)) |>
    rlang::set_names(sensitive_labels)
  
  df_persona_per_group <- bind_rows(df_persona_list)
  
  ## Save this file as an Excel spreadsheet
  output_path <- file.path("R/data", "df_persona_per_group.xlsx")
  writexl::write_xlsx(df_persona_per_group, output_path)
  
  ## Load the personas
  df_persona_all <- get_df_persona_recursive(df_sp_enrollments)
  
  return(df_persona_all)
}

