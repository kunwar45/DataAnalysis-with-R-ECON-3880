library(gtsummary)
library(shiny)
library(gt)

# create the Shiny app
ui <- fluidPage(
  # Inputs: Select Age Range
  sidebarPanel(
    sliderInput(
      inputId = "age_range",
      label = "Age Range",
      min = 5, max = 85,
      value = c(5, 85), step = 5
    )
  ),
  
  # place summary table on main page
  gt_output(outputId = "my_gt_table")
)

server <- function(input, output, session) {
  output$my_gt_table <-
    render_gt(
      trial %>%
        # filter out patients outside of age range
        dplyr::filter(
          dplyr::between(age, input$age_range[1], input$age_range[2])
        ) %>%
        # build a gtsummary table
        tbl_summary(
          by = trt,
          type = age ~ "continuous",
          include = c(age, grade, response),
          missing = "no"
        ) %>%
        add_stat_label() %>%
        add_n() %>%
        # CONVERT TO A {gt} TABLE! VERY IMPORTANT STEP!
        as_gt() %>%
        tab_header(md("**Table 1. Patient Characteristics**"))
    )
}

# Run the application
shinyApp(ui = ui, server = server)