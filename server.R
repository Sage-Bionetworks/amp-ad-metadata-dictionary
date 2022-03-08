server <- function(input, output, session) {
  syn <- synapse$Synapse()
  syn$setEndpoints(
    repoEndpoint='https://repo-staging.prod.sagebase.org/repo/v1',
    authEndpoint='https://auth-staging.prod.sagebase.org/auth/v1',
    fileHandleEndpoint='https://file-staging.prod.sagebase.org/file/v1',
    portalEndpoint='https://staging.synapse.org/'
  )

  ## Get annotations
  annots <- get_synapse_table(synID = "syn10242922", syn = syn)
  annots <- select(annots, -maximumSize)

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
