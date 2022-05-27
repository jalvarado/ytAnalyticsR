generate_request <- function(endpoint = character(),
                             params = list(),
                             key = NULL,
                             token = yt_analytics_token(),
                             base_url = attr(.endpoints, "base_url")) {
  ept <- .endpoints[[endpoint]]

  if (is.null(ept)) {
    stop(sprintf("\nEndpoint not recognized: \n %s", endpoint))
  }

  req <- gargle::request_develop(endpoint = ept, params = params)
  gargle::request_build(
    path = req$path,
    method = req$method,
    params = req$params,
    body = req$body,
    token = token,
    base_url = base_url
  )
}
