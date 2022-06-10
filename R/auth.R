.auth <- NULL

#   "https://www.googleapis.com/auth/yt-analytics-monetary.readonly",
#   "https://www.googleapis.com/auth/youtubepartner",
#   "https://www.googleapis.com/auth/youtube",
default_scopes <- c(
  "https://www.googleapis.com/auth/youtube.readonly",
  "https://www.googleapis.com/auth/yt-analytics.readonly"
)


#' Authorize YouTube Analytics API
#'
#' Authorize 'ytAnalyticsR' to query the YouTube Analytics and Reporting APIs
#'
#' By default you are directred to a web browser, asked to sign in to your Google
#' account, and to grant ytAnalyticsR permission to operate on your behalf with
#' YouTube Analytics and Reporting.
#'
#' @param email Optional. Allows user to target a specific Google identity. Defaults to the option named "gargle_oauth_email", retrieved by gargle_oauth_email().
#' @param scopes A character vector of scopes to request.
#' @param cache Specified the OAuth token cache. Defaults to the option named "gargle_oauth_cache", retrieved via gargle_oauth_cache().
#' @param use_oob Whether to prefer "out of band" authentication. Defaults to the option named "gargle_oob_default", retrieved via gargle_oob_default().
#' @param token A token with class Token2.0 or an object of httr's class request, i.e. a token that has been prepared with httr::config() and has a Token2.0 in the auth_token component.
#'
#' @family auth
#' @export
#'
#' @examples
#' if (FALSE) {
#'   # Load/refresh existing credentials if available
#'   # otherwise go through the OAuth 2.0 flow for authorization
#'   # and authentication.
#'   yt_analytics_auth()
#'
#'   # Force use of a token specified by the given email
#'   yt_analytics_auth(email = "user@example.com")
#'
#'   # Force the OAuth web flow
#'   yt_analytics_auth(email = NA)
#' }
yt_analytics_auth <- function(email = gargle::gargle_oauth_email(),
                              scopes = default_scopes,
                              cache = gargle::gargle_oauth_cache(),
                              use_oob = gargle::gargle_oob_default(),
                              token = NULL) {
  cred <- gargle::token_fetch(
    scopes = scopes,
    app = yt_analytics_oauth_app(),
    email = email,
    package = "ytanalyticsr",
    cache = cache,
    use_oob = use_oob,
    token = token
  )

  if (!inherits(cred, "Token2.0")) {
    stop("Can't get google credentials.")
  }

  .auth$set_cred(cred)
  .auth$set_auth_active(TRUE)

  # use the auth token we just fetched to auth with tubeR as well
  options(google_token = .auth$cred)

  invisible()
}

#' Remove any existing credentials for the current session.
#'
#' @export
yt_analytics_deauth <- function() {
  .auth$set_auth_active(FALSE)
  .auth$clear_cred()
  invisible()
}

#' Fetch an authentication token from Google OAuth services if one has not
#' already been fetched.
#'
#' @return httr::config
#' @export
yt_analytics_token <- function() {
  if (isFALSE(.auth$auth_active)) {
    return(NULL)
  }
  if (!yt_analytics_has_token()) {
    yt_analytics_auth()
  }
  httr::config(token = .auth$cred)
}

#' Change the defaults used during the authentication process.
#'
#' @param app httr::oauth_app
#' @param path String path pointing to a JSON file describing an OAuth 2.0 app
#' @param api_key String containing an API key that can be used to authenticate
#' with Google APIs
#'
#' @export
yt_analytics_auth_configure <- function(app, path, api_key) {
  if (!missing(app) && !missing(path)) {
    stop("Must supply exactly one of {.arg app} or {.arg path}, not both")
  }
  stopifnot(missing(api_key) || is.null(api_key) || is_string(api_key))

  if (!missing(path)) {
    stopifnot(is_string(path))
    app <- gargle::oauth_app_from_json(path)
  }
  stopifnot(missing(app) || is.null(app) || inherits(app, "oauth_app"))

  if (!missing(app) || !missing(path)) {
    .auth$set_app(app)
  }

  if (!missing(api_key)) {
    .auth$set_api_key(api_key)
  }

  invisible(.auth)
}

#' Check if there is currently an OAuth 2.0 token available in the
#' auth object.
#'
#' @return logical
#'
#' @export
yt_analytics_has_token <- function() {
  inherits(.auth$cred, "Token2.0")
}

#' Retrieve the current OAuth application from the auth object.
#'
#' @return httr::oauth_app
#' @export
yt_analytics_oauth_app <- function() .auth$app

# These functions are used for testing only and are not exported
skip_if_no_auth <- function() {
  testthat::skip_if_not(yt_analytics_has_token(), "Authentication not available")
}
