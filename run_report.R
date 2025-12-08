library(shiny)
library(zip)
source("render_functions.R")

ui <- fluidPage(
  # Custom CSS for centering and styling
  tags$head(tags$style(
    HTML(
      "
      body {
        background-color: #f8f9fa;
        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
      }
      .center-box {
        max-width: 700px;
        margin: 0 auto;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0px 4px 12px rgba(0,0,0,0.1);
      }
      h2 {
        text-align: center;
        margin-bottom: 20px;
      }
      .btn {
        width: 100%;
      }
      #log {
        background: #f1f1f1;
        padding: 10px;
        border-radius: 6px;
        font-family: monospace;
      }
      iframe {
        border: 1px solid #ddd;
        border-radius: 8px;
      }
    "
    )
  )),
  
  fluidRow(column(
    12,
    div(
      class = "center-box",
      h2("No Fairness without Awareness"),
      
      selectInput("report_type", "Report type", c("Basic", "Advanced")),
      selectInput("sp", "Studyprogram", c("CMD", "VD", "BO", "ES-ES")),
      selectInput("sp_form", "Studyprogram Form", c("VT", "DT", "DU")),
      fileInput("cho_file", "Upload 1CHO data",
                accept = c(".csv", ".xlsx", ".xls", ".txt")),
      
      actionButton("go", "Generate report", class = "btn btn-primary"),
      br(),
      br(),
      downloadButton("download_report", "Download Report (ZIP)", class =
                       "btn btn-success"),
      br(),
      br(),
      
      h4("Log"),
      verbatimTextOutput("log"),
      br(),
      h4("Preview"),
      uiOutput("preview")
    )
  ))
)

server <- function(input, output, session) {
  report_dir <- reactiveVal(NULL)
  report_file <- reactiveVal(NULL)
  
  observeEvent(input$go, {
    withProgress(message = "Rendering report...", value = 0, {
      incProgress(0.1)
      
      # include uploaded file path if provided
      cho_path <- if (!is.null(input$cho_file)) input$cho_file$datapath else NULL
      
      # include 
      params <- list(sp = input$sp, sp_form = input$sp_form)
      incProgress(0.4)
      
      if (input$report_type == "Basic") {
        render_basic_report(params)
        out_dir  <- "_basic-report"
      } else {
        render_advanced_report(params)
        out_dir  <- "_advanced-report"
      }
      
      out_html <- file.path(out_dir, "index.html")
      
      incProgress(0.9)
      
      report_dir(normalizePath(out_dir))
      report_file(normalizePath(out_html))
      
      # Expose the output folder to Shiny at /report
      addResourcePath("report", report_dir())
      
      output$log <- renderText({
        paste(
          "Report generated with studyprogram =",
          input$sp,
          "and studyprogram form =",
          input$sp_form
        )
      })
      
      # Use relative path served by Shiny
      output$preview <- renderUI({
        tags$iframe(
          src = paste0("report/", basename(report_file())),
          width = "100%",
          height = "600px"
        )
      })
      
      incProgress(1)
    })
    
    output$download_report <- downloadHandler(
      filename = function() {
        paste0(input$report_type, "-report.zip")
      },
      content = function(file) {
        # Get all files inside report_dir
        files <- list.files(report_dir(),
                            recursive = TRUE,
                            full.names = TRUE)
        
        # Create zip with relative paths (without absolute path leakage)
        old_wd <- setwd(report_dir())
        on.exit(setwd(old_wd), add = TRUE)
        zip::zip(zipfile = file,
                 files = list.files(".", recursive = TRUE))
      }
    )
    
  })
  
  
}

shinyApp(ui, server)
