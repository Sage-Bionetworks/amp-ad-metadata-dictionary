ui <- function() {
  fluidPage(
    tags$head(
      singleton(
        includeScript("www/readCookie.js")
      )
    ),
    waiter::use_waiter(),
    waiter::waiter_show_on_load(
      html = tagList(
        img(src = "loading.gif"),
        h4("Connecting to Synapse...")
      ),
      color = "#424874"
    ),

    titlePanel("AMP-AD Metadata Dictionary"),

    fluidRow(
      column(
        12,
        reactableOutput("annotations_table")
      )
    )
  )
}
