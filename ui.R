ui <- function() {
  fluidPage(
    tags$head(
      singleton(
        includeScript("www/readCookie.js")
      )
    ),

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
