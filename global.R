## Load packages
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("purrr"))
suppressPackageStartupMessages(library("reactable"))
suppressPackageStartupMessages(library("reticulate"))
suppressPackageStartupMessages(library("shiny"))

if (Sys.getenv("R_CONFIG_ACTIVE") == "shinyapps") {
  venv_folder<-"virtual_env"
  if (!file.exists(venv_folder)) {
    reticulate::virtualenv_create(envname = venv_folder, python = '/usr/bin/python3')
   	reticulate::virtualenv_install(venv_folder, packages = c('synapseclient', 'pandas'))
   }
   reticulate::use_virtualenv(venv_folder, required = T)
}

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
