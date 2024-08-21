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
# reticulate::use_condaenv("synapse")
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

#' Format a Data Dictionary Table
#'
#' This function reads a schematic-formated data model csv from a raw github url and formats the data frame for use in the AD metadata dictionary shiny app.
#'
#' @param data_model_url A character string specifying the URL of the CSV file containing the data model.
#' @return A tibble containing the formatted data dictionary with columns, descriptions, and associated attributes.
#' @import dplyr
#' @import tibble
#' @importFrom utils read.csv
#' @importFrom stats url
#' @export
format_dict_table <- function(data_model_url) {

  data_model <- tibble::as_tibble(read.csv(url(data_model_url)))

  col_attribs <- data_model |>
    dplyr::filter(Parent == 'ManifestColumn') |>
    dplyr::select(
      Column = Attribute,
      `Column Description` = Description,
      Required,
      `Column Type` = columnType,
      `Data Model Module` = module
    )

  val_attribs <- data_model |>
    dplyr::filter(Parent %in% col_attribs$Column) |>
    dplyr::select(
      Value = Attribute,
      `Value Description` = Description,
      Source,
      Column = Parent
    )

  dict_table <- col_attribs |>
    dplyr::left_join(val_attribs, relationship = "many-to-many") |>
    dplyr::relocate(`Data Model Module`, .after = Source)

  return(dict_table)

}
