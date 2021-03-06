reports.query <- function(metrics = NULL, filters = NULL, ids = NULL,
                          endDate = NULL, startDate = NULL, dimensions = NULL,
                          startIndex = NULL, sort = NULL, maxResults = NULL) {
  params <- list(
    startDate = startDate,
    endDate = endDate,
    metrics = metrics,
    dimensions = dimensions,
    filters = filters,
    sort = sort,
    ids = ids,
    startIndex = startIndex,
    maxResults = maxResults
  )
  req <- generate_request(
    endpoint = "youtubeAnalytics.reports.query",
    params = rmNullObs(params)
  )
  resp <- gargle::response_process(make_request(req))

  response_to_data_frame(resp)
}
