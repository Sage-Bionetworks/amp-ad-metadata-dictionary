server <- function(input, output, session) {
  syn <- synapse$Synapse()
  session$sendCustomMessage(type = "readCookie", message = list())

  ## Show message if user is not logged in to synapse
  unauthorized <- observeEvent(input$authorized, {
    showModal(
      modalDialog(
        title = "Not logged in",
        HTML("You must log in to <a href=\"https://www.synapse.org/\">Synapse</a> to use this application. Please log in, and then refresh this page.")
      )
    )
  })

  observeEvent(input$cookie, {
    is_logged_in <- FALSE
    ## Use authToken and handle error here if still not logged in
    tryCatch({
      syn$login(sessionToken = input$cookie, silent = TRUE)
      is_logged_in <- TRUE
    },
    error = function(err) {
      showModal(
        modalDialog(
          title = "Login error",
          HTML("There was an error with the login process. Please refresh your Synapse session by logging out of and back in to <a target=\"_blank\" href=\"https://www.synapse.org/\">Synapse</a>. Then refresh this page to use the application."), # nolint
          footer = NULL
        )
      )
    }
    )
    ## Check that user did not log in as anonymous
    if (syn$username == "anonymous") {
      showModal(
        modalDialog(
          title = "Login error",
          HTML("There was an error with the login process. You have been logged in as anonymous."), # nolint
          footer = NULL
        )
      )
      is_logged_in <- FALSE
    }
    req(is_logged_in)

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
  })
}
