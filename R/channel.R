#' Query the analytics API for channel metrics
#'
#' @param channel_id YouTube channel ID string
#' @param start_date Beginning date of the query date range
#' @param end_date End date of the query date range
#' @param metrics Comma-seperated string of metric names
#' @param dimensiosn Comma-seperated string of dimension names
#' @param sort Comma-seperated string of dimension names to sort by.  Prepend
#' dimension names with '-' to sort that dimension in descending order
#' @param filters Semi-colon seperated string of filter conditions to apply
#' to the result set.
#' @param max_results Maximum number of results to return. (default 1000)
#'
#' @return data.frame containing the API response rows
#'
#' @export
channel.query <- function(channel_id, start_date = NULL, end_date = NULL,
                          metrics = NULL, dimensions = NULL, sort = NULL,
                          filters = NULL, max_results = NULL) {

  reports.query(
    startDate = start_date,
    endDate = end_date,
    metrics = metrics,
    dimensions = dimensions,
    sort = sort,
    filters = filters,
    maxResults = max_results,
    ids = paste0("channel==", channel_id)
  )
}

#' Query the Analytics API for channel demographics metrics
#'
#' @param channel_id YouTube channel ID
#' @param start_date Beginning date of the query date range. YYYY-mm-dd
#' @param end_date End date of the query date range. YYYY-mm-dd
#'
#' @return data.frame
#'
#' @export
channel.demographics <- function(channel_id,
                                 start_date = NULL, end_date = NULL,
                                 filters = NULL) {
  api_args <- list(
    start_date = start_date,
    end_date = end_date,
    metric = "viewerPercentage",
    dimensions = "gender,ageGroup",
    sort = "gender,ageGroup"
  )

  do.call(channel.query, c(channel_id, rmNullObs(api_args)))
}