#' Make an API request to a Google API
#'
#' @family requests
#' @export
make_request <- function(x, ..., user_agent = gargle_user_agent()) {
  gargle::request_make(x, ..., user_agent = yt_analytics_ua())
}

yt_analytics_ua <- function() {
  httr::user_agent(paste0(
    "ytAnalyticsR/", utils::packageVersion("ytAnalyticsR"), " ",
    "gargle/", utils::packageVersion("gargle"), " ",
    "httr/", utils::packageVersion("httr")
  ))
}
