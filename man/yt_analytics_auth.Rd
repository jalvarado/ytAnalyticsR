% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auth.R
\name{yt_analytics_auth}
\alias{yt_analytics_auth}
\title{Authorize YouTube Analytics API}
\usage{
yt_analytics_auth(
  email = gargle::gargle_oauth_email(),
  scopes = default_scopes,
  cache = gargle::gargle_oauth_cache(),
  use_oob = gargle::gargle_oob_default(),
  token = NULL
)
}
\arguments{
\item{email}{Optional. Allows user to target a specific Google identity. Defaults to the option named "gargle_oauth_email", retrieved by gargle_oauth_email().}

\item{scopes}{A character vector of scopes to request.}

\item{cache}{Specified the OAuth token cache. Defaults to the option named "gargle_oauth_cache", retrieved via gargle_oauth_cache().}

\item{use_oob}{Whether to prefer "out of band" authentication. Defaults to the option named "gargle_oob_default", retrieved via gargle_oob_default().}

\item{token}{A token with class Token2.0 or an object of httr's class request, i.e. a token that has been prepared with httr::config() and has a Token2.0 in the auth_token component.}
}
\description{
Authorize 'ytAnalyticsR' to query the YouTube Analytics and Reporting APIs
}
\details{
By default you are directred to a web browser, asked to sign in to your Google
account, and to grant ytAnalyticsR permission to operate on your behalf with
YouTube Analytics and Reporting.
}
\examples{
if (FALSE) {
  # Load/refresh existing credentials if available
  # otherwise go through the OAuth 2.0 flow for authorization
  # and authentication.
  yt_analytics_auth()

  # Force use of a token specified by the given email
  yt_analytics_auth(email = "user@example.com")

  # Force the OAuth web flow
  yt_analytics_auth(email = NA)
}
}
\concept{auth}
