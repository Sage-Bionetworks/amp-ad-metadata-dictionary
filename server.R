server <- function(input, output, session) {

  # Get data model csv and re-format for dictionary app
  # use reactive expression to get latest version of data model
  dict_table <- reactive({
    df <- format_dict_table(data_model_url)
    as.data.frame(df)  # Ensure the result is a data frame
  })

  ## Create table to display
  output$dictionary_table <- renderReactable({
    reactable(
      dict_table(),
      groupBy = "Column",
      searchable = TRUE,
      sortable = TRUE,
      theme = reactable::reactableTheme(
        searchInputStyle = list(width = "100%")
      ),
      columns = list(
        Column = colDef(
          name = "Column",
          filterable = TRUE
        ),
        `Column Description` = colDef(
          name = "Column Description",
          aggregate = "unique",
          filterable = TRUE
        ),
        `Column Type` = colDef(
          name = "Column Type",
          aggregate = "unique",
          filterable = TRUE
        ),
        `Value` = colDef(
          name = "Value",
          aggregate = truncated_values,
          filterable = TRUE
        ),
        `Value Description` = colDef(
          name = "Value Description",
          aggregate = reactable::JS("function(values, rows) { return '...' }"),
          filterable = TRUE
        ),
        Source = colDef(
          name = "Source",
          aggregate = reactable::JS("function(values, rows) { return '...' }"),
          filterable = TRUE
        ),
        `Data Model Module` = colDef(
          name = "Data Model Module",
          aggregate = "unique",
          filterable = TRUE
        )
      )
    )
  })
}
