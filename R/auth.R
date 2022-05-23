#' Authenticate with the YouTube API
#'
#' @param email An existing cached email to authenticate with.
#' @param scopes Scopes to use in the API requests
#' @param cache Where to store the authentication tokens
#'
#' @return an OAuth token object.
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
