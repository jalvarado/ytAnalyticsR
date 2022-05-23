#' Authenticate with the YouTube API
#'
#' @param email An existing cached email to authenticate with.
#' @param scopes Scopes to use in the API requests
#' @param cache Where to store the authentication tokens
#'
#' @return an OAuth token object.
#'
#' @examples
#' \dontrun {
#' # starts the auth process with default options
#' yt_auth()
#'
#' # switch between cached authentication credentials
#' # by providing an email cache key.
#' # The first time you use the new scope you will go through the regular
#' # authentication flow.  Subsequent calls with automatically authenticate.
#' yt_auth(email = "your@email.com")
#'
#' # ... query the YouTube Analytics API ...
#' }
#'
#' @import googleAuthR
#' @export
yt_auth <- function(email = NULL,
                    scopes = c(
                      "https://www.googleapis.com/auth/youtube",
                      "https://www.googleapis.com/auth/youtube.readonly",
                      "https://www.googleapis.com/auth/yt-analytics-monetary.readonly",
                      "https://www.googleapis.com/auth/yt-analytics.readonly"
                    ),
                    cache = gargle::gargle_oauth_cache()) {

  googleAuthR::gar_auth(email = email,
                        scopes = scopes,
                        cache = cache,
                        package = "ytanalyticsr")
}
