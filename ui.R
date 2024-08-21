ui <- function() {
  fluidPage(
    titlePanel("AD Metadata Dictionary"),

    fluidRow(
      column(
        8,
        p("Explore AD metadata template columns by column name, value, or description. ",
          "You can use the large search bar to query the entire table, ",
          "the small search bars underneath the column names to query by ",
          "column, and the pagination at the bottom to flip through the table."
        )
      ),
      column(
        12,
        reactableOutput("dictionary_table")
      )
    )
  )
}
