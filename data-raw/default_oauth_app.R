readRenviron(".Renv")

goa <- httr::oauth_app(
  appname = "ytAnalyticsR",
  key = Sys.getenv("YTA_OAUTH_CLIENT_ID"),
  secret = Sys.getenv("YTA_OAUTH_CLIENT_SECRET")
)
