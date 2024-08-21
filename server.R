server <- function(input, output, session) {

  # Get data model csv and re-format for dictionary app
  dict_table <- format_dict_table(data_model_url)

  ## Create table to display
  output$annotations_table <- renderReactable({
    reactable(
      annots,
      groupBy = "key",
      searchable = TRUE,
      sortable = TRUE,
      theme = reactable::reactableTheme(
        searchInputStyle = list(width = "100%")
      ),
      columns = list(
        key = colDef(
          name = "Key",
          filterable = TRUE
        ),
        description = colDef(
          name = "Key description",
          aggregate = "unique",
          filterable = TRUE
        ),
        columnType = colDef(
          name = "Type",
          aggregate = "unique",
          filterable = TRUE
        ),
        value = colDef(
          name = "Value",
          aggregate = truncated_values,
          filterable = TRUE
        ),
        valueDescription = colDef(
          name = "Value description",
          aggregate = reactable::JS("function(values, rows) { return '...' }"),
          filterable = TRUE
        ),
        source = colDef(
          name = "Source",
          aggregate = reactable::JS("function(values, rows) { return '...' }"),
          filterable = TRUE
        ),
        module = colDef(
          name = "Module",
          aggregate = "unique",
          filterable = TRUE
        )
      )
    )
  })
}
