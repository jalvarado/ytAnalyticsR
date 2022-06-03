source("./data-raw/default_oauth_app.R")
#str(oauth_app)

source("./data-raw/discovery-doc-ingest.R")
#str(.endpoints)

usethis::use_data(goa, .endpoints, internal = TRUE, overwrite = TRUE)