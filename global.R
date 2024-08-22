## Load packages
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("purrr"))
suppressPackageStartupMessages(library("reactable"))
suppressPackageStartupMessages(library("shiny"))

## Global variables
data_model_url <- "https://raw.githubusercontent.com/adknowledgeportal/data-models/main/AD.model.csv"

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
#' @importFrom utils read.csv
#' @importFrom stats url
#' @export
format_dict_table <- function(data_model_url) {

  data_model <- read.csv(url(data_model_url))

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
