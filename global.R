## Load packages
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("purrr"))
suppressPackageStartupMessages(library("reactable"))
suppressPackageStartupMessages(library("reticulate"))
suppressPackageStartupMessages(library("shiny"))
suppressPackageStartupMessages(library("httr"))
suppressPackageStartupMessages(library("rjson"))



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
syn <- synapse$Synapse()

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

has_auth_code <- function(params) {
  # params is a list object containing the parsed URL parameters. Return TRUE if
  # based on these parameters, it looks like auth code is present that we can
  # use to get an access token. If not, it means we need to go through the OAuth
  # flow.
  return(!is.null(params$code))
}

client_id <- Sys.getenv("OAUTH_CLIENT_ID")
client_secret <- Sys.getenv("OAUTH_CLIENT_SECRET")
app_url <- Sys.getenv("APP_URL")
if (is.null(client_id) || nchar(client_id)==0) stop(".Renviron is missing OAUTH_CLIENT_ID")
if (is.null(client_secret) || nchar(client_secret)==0) stop(".Renviron is missing OAUTH_CLIENT_SECRET")
if (is.null(app_url) || nchar(app_url)==0) stop(".Renviron is missing APP_URL")


app <- oauth_app("meta-dictionary",
                 key = client_id,
                 secret = client_secret, 
                 redirect_uri = app_url)

# These are the user info details ('claims') requested from Synapse:
claims=list(
  userid=NULL
)

claimsParam<-toJSON(list(id_token = claims, userinfo = claims))
api <- oauth_endpoint(
  authorize=paste0("https://signin.synapse.org?claims=", claimsParam),
  access="https://repo-prod.prod.sagebase.org/auth/v1/oauth2/token"
)

# The 'openid' scope is required by the protocol for retrieving user information.
scope <- "openid view download"
