#' Query the analytics API for playlist metrics
#'
#' @export
playlists.query <- function(playlist_id, startDate = NULL, endDate = NULL, metrics = NULL,
                            dimensions = NULL, sort = NULL, filters = NULL, ids = c("channel==MINE")) {
  # When querying the API for playlist metrics, the filters must include
  # 'isCurated==1'
  curated_filter <- c('isCurated==1')
  playlist_filter <- paste0('playlist==', playlist_id)

  # Check if the isCurated filter has already been passed through the filters
  # argument before adding it.
  if(is.null(filters) || grepl(curated_filter, filters, fixed=TRUE)) {
    all_filters <- paste(curated_filter, filters, sep=";")
  } else {
    all_filters <- filters
  }

  # Add the playlist id to the filter so we only get the metrics for the specified
  # playlist.
  all_filters < paste(all_filters, playlist_filter, sep=";")

  api_args <- list(metrics = metrics, filters = all_filters, startDate = startDate,
                  endDate = endDate, dimensions = dimensions, sort = sort, ids = ids)
  r <- do.call(reports.query, rmNullObs(api_args))

  df <- as.data.frame(r$rows)
  colnames(df) <- c(r$columnHeaders$name)

  df
}
