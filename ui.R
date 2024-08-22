ui <- function() {
  fluidPage(
    titlePanel("AD Metadata Dictionary"),

    fluidRow(
      column(
        8,
        p("Explore AD metadata template columns by name, value, or description. ",
          "You can use the large search bar at the top to query the entire dictionary, ",
          "the small search bars underneath the dictionary column names to query by ",
          "dictionary column, and the pagination at the bottom to flip through the table."
        )
      ),
      column(
        12,
        reactableOutput("dictionary_table")
      )
    )
  )
}
