## Load packages
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("purrr"))
suppressPackageStartupMessages(library("reactable"))
suppressPackageStartupMessages(library("reticulate"))
suppressPackageStartupMessages(library("shiny"))

## Load synapse client
synapse <- reticulate::import("synapseclient")

## Function to truncate display in table
truncated_values <- JS("
  function(values, rows) {
    joined = values.join(', ')
    if (joined.length <= 20) {
      return joined
    }
    return joined.slice(0, 20) + '...'
  }
")

get_synapse_table <- function(synID, syn) {
  query_result <- syn$tableQuery(
    glue::glue("select * from {synID}"),
    includeRowIdAndRowVersion = FALSE
  )
  dat <- utils::read.csv(
    query_result$filepath,
    na.strings = "",
    stringsAsFactors = FALSE
  )
  dat
}
