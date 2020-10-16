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
    tryCatch({
      syn$login(sessionToken = input$cookie)
      ## Get annotations
      annots <- map_dfr(
        c("syn10242922", "syn21459391"),
        get_synapse_table,
        syn = syn
      )
      annots <- select(annots, -maximumSize)

      ### update waiter loading screen once login successful
      waiter::waiter_update(
        html = tagList(
          img(src = "synapse_logo.png", height = "120px"),
          h3(sprintf("Welcome, %s!", syn$getUserProfile()$userName))
        )
      )
      Sys.sleep(2)
      waiter::waiter_hide()
    }, error = function(err) {
      Sys.sleep(2)
      waiter::waiter_update(
        html = tagList(
          img(src = "synapse_logo.png", height = "120px"),
          h3("Looks like you're not logged in!"),
          span(
            "Please ",
            a(
              "log in",
              href = "https://www.synapse.org/#!LoginPlace:0",
              target = "_blank"
            ),
            " to Synapse, then refresh this page."
          )
        )
      )
    })

    ## Create table to display
    output$annotations_table <- renderReactable({
      reactable(
        annots,
        groupBy = "key",
        searchable = TRUE,
        sortable = TRUE,
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
