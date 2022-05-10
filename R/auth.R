#' Authenticate with the YouTube API
#'
#' A wrapper for googleAuthR::gar_auth
#'
#' If you have set the environment variable \code{YT_AUTH_FILE} to a valid file location,
#'   the function will look there for authentication details.
#' Otherwise it will look in the working directory for hte '.httr-oauth' file, whicih if not present
#'   will trigger an authentication flow via Google login screen in your browser.
#'
#' @return Invisibly, the token that has been saved to the session
#' @import googleAuthR
#' @export
yt_auth <- function() {
  required_scopes <- c(
    "https://www.googleapis.com/auth/youtube",
    "https://www.googleapis.com/auth/youtube.readonly",
    "https://www.googleapis.com/auth/yt-analytics-monetary.readonly",
    "https://www.googleapis.com/auth/yt-analytics.readonly"
  )

  googleAuthR::gar_auth()
}
