suppressPackageStartupMessages(library("shiny"))
suppressPackageStartupMessages(library("httr"))

server <- function(input, output, session) {
  access_token <- session$userData$access_token
  if (is.null(access_token)) {
  	params <- parseQueryString(isolate(session$clientData$url_search))
  	if (!has_auth_code(params)) {
    	stop("No access token and no authorization code.")
  	}
  	token_url <- paste0(api$access, '?', 'redirect_uri=',
                         app$redirect_uri, '&grant_type=',
                         'authorization_code' ,'&code=', params$code)
  	# get the access_token and userinfo token
  	response <- POST(token_url,
              encode = "form",
              body = '',
              authenticate(app$key, app$secret, type = "basic"),
              config = list())
  	# Stop the code if anything other than 2XX status code is returned
  	stop_for_status(response, task = "get an access token")
  	token_response <- content(response, type = NULL)
  	access_token <- token_response$access_token
  	session$userData$access_token <- access_token
  }
  syn$login(authToken = access_token)

	## Get annotations
	annots <- get_synapse_table(synID = "syn10242922", syn = syn)
	
	annots <- select(annots, -maximumSize)
	
	## Create table to display
	output$annotations_table <- renderReactable({
	  reactable(
	    annots,
	    groupBy = "key",
	    searchable = TRUE,
	    sortable = TRUE,
	    theme = reactable::reactableTheme(
	      searchInputStyle = list(width = "100%")
	    ),
	    columns = list(
	      key = colDef(
	        name = "Key",
	        filterable = TRUE
	      ),
	      description = colDef(
	        name = "Key description",
	        aggregate = "unique",
	        filterable = TRUE
	      ),
	      columnType = colDef(
	        name = "Type",
	        aggregate = "unique",
	        filterable = TRUE
	      ),
	      value = colDef(
	        name = "Value",
	        aggregate = truncated_values,
	        filterable = TRUE
	      ),
	      valueDescription = colDef(
	        name = "Value description",
	        aggregate = reactable::JS("function(values, rows) { return '...' }"),
	        filterable = TRUE
	      ),
	      source = colDef(
	        name = "Source",
	        aggregate = reactable::JS("function(values, rows) { return '...' }"),
	        filterable = TRUE
	      ),
	      module = colDef(
	        name = "Module",
	        aggregate = "unique",
	        filterable = TRUE
	      )
	    )
	  )
	})
    
}
