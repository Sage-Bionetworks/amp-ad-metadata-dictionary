ui <- function() {
  fluidPage(
    tags$head(
      singleton(
        includeScript("www/readCookie.js")
      )
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
