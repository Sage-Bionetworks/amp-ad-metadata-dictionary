suppressPackageStartupMessages(library("shiny"))
suppressPackageStartupMessages(library("httr"))

ui <- function() {
  fluidPage(
    titlePanel("AD Metadata Dictionary"),

    fluidRow(
      column(
        8,
        p("Explore AD metadata terms by key, value, or descriptions. ",
          "You can use the large search bar to query the entire table, ",
          "the small search bars underneath the column names to query by ",
          "column, and the pagination at the bottom to flip through the table."
        )
      ),
      column(
        12,
        reactableOutput("annotations_table")
      )
    )
  )
}

uiFunc <- function(req) {
  if (!has_auth_code(parseQueryString(req$QUERY_STRING))) {
    authorization_url = oauth2.0_authorize_url(api, app, scope = scope)
    return(tags$script(HTML(sprintf("location.replace(\"%s\");",
                                    authorization_url))))
  } else {
    ui()
  }
}
