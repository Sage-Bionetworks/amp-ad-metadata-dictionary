## Load packages
library("dplyr")
library("reactable")
library("reticulate")
library("shiny")

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
