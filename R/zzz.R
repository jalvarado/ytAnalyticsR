.onLoad <- function(libname, pkgname) {
  google_oauth <- function() {
    oauth_app <- httr::oauth_app(
      appname = "ytAnalyticsR",
      key = "474964907849-n1odgqs9fucaq0imhhk0r9qriui1706n.apps.googleusercontent.com",
      secret = "Un7yL2fOt-zjGDCb5FJsauMC"
    )
  }


  # .auth is created in R/auth.R
  # this is to insure we get an instance of gargle's AuthState using the
  # current, locally installed version of gargle
  utils::assignInMyNamespace(
    ".auth",
    gargle::init_AuthState(
      package = "ytanalyticsr",
      auth_active = TRUE,
      app = google_oauth
    )
  )
}
