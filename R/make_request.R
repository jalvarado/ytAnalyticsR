#' Make an API request to a Google API
#'
#' @inheritParams gargle::request_make
#'
#' @family requests
#' @export
make_request <- function(x, ..., user_agent = yt_analytics_ua()) {
  gargle::request_make(x, ..., user_agent = user_agent)
}

yt_analytics_ua <- function() {
  httr::user_agent(paste0(
    "ytAnalyticsR/", utils::packageVersion("ytAnalyticsR"), " ",
    "gargle/", utils::packageVersion("gargle"), " ",
    "httr/", utils::packageVersion("httr")
  ))
}
