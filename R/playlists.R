#' Query the analytics API for playlist metrics.
#'
#' The playlist ID will be added as a dimension to the returned data.frame.
#'
#' @param playlist_id YouTube Playlist ID string
#' @param start_date Beginning date of the query date range.
#' @param end_date End date of the query date range.
#' @param metrics Comma seperated string of requested metrics.
#' @param dimensions Comma seperated string of requested dimensions.
#' @param sort Comma seperated string of dimensions to sort by.  Prepend
#'  dimension name with '-' to indicate a descending sort.
#' @param filters semi-colon seperated string of filter conditions to apply
#'  to the result set.
#' @param ids ID string used to determine which channel or content owner to
#'  query for data
#'
#' @return data.frame containing the API response rows.
#'
#' @export
playlists.query <- function(playlist_id, start_date = NULL,
                            end_date = NULL, metrics = NULL,
                            dimensions = NULL, sort = NULL,
                            filters = NULL, ids = c("channel==MINE")) {
  curated_filter <- c("isCurated==1")
  playlist_filter <- paste0("playlist==", playlist_id)

  # Check if the isCurated filter has already been passed through the filters
  # argument before adding it.
  if (is.null(filters) || grepl(curated_filter, filters, fixed = TRUE)) {
    all_filters <- paste(curated_filter, filters, sep = ";")
  } else {
    all_filters <- filters
  }

  # Add the playlist id to the filter so we only get the metrics for the
  # specified playlist.
  all_filters < paste(all_filters, playlist_filter, sep = ";")

  api_args <- list(
    metrics = metrics, filters = all_filters, startDate = start_date,
    endDate = end_date, dimensions = dimensions, sort = sort, ids = ids
  )
  r <- do.call(reports.query, rmNullObs(api_args))

  if (length(r$rows) == 0) {
    df <- data.frame(matrix(ncol = length(r$columnHeaders$name) + 1, nrow = 0))
    colnames(df) <- c(r$columnHeaders$name, "playlist_id")
  } else {
    df <- as.data.frame(r$rows)
    colnames(df) <- c(r$columnHeaders$name)
    df["playlist_id"] <- playlist_id
  }

  df
}

#' Take a vector of playlist ids and call playlists.query for each.
#'
#' @param playlist_ids vector of YouTube Playlist ID strings
#' @param start_date Beginning date of the query date range.
#' @param end_date End date of the query date range.
#' @param metrics Comma seperated string of requested metrics.
#' @param dimensions Comma seperated string of requested dimensions.
#' @param sort Comma seperated string of dimensions to sort by.  Prepend
#'  dimension name with '-' to indicate a descending sort.
#' @param filters semi-colon seperated string of filter conditions to apply
#'  to the result set.
#' @param ids ID string used to determine which channel or content owner to
#'  query for data
#'
#' @return data.frame containing the API response rows.
#'
#' @return data.frame containing the results from all queries
#'
#' @export
vplaylist.query <- function(playlist_ids, ...) {
  dfs <- list()
  for (id in playlist_ids) {
    df <- playlists.query(id, ...)
    dfs <- append(dfs, list(df))
  }

  do.call(what = rbind, args = dfs)
}


#' Query the Analytics API for playlist demographics metrics
#'
#' @param playlist_id YouTube Playlist ID string
#' @param start_date Beginning date of the query date range.
#' @param end_date End date of the query date range.
#'
#' @return DataFrame
#'
#' @export
playlist.demographics <- function(playlist_id, start_date = NULL,
                                  end_date = NULL) {
  api_args <- list(
    startDate = start_date,
    endDate = end_date,
    ids = "channel==MINE",
    filters = paste0("isCurated==1;playlist==", playlist_id),
    metric = "viewerPercentage",
    dimensions = "gender,ageGroup",
    sort = "gender,ageGroup"
  )

  r <- do.call(reports.query, rmNullObs(api_args))

  if (length(r$rows) == 0) {
    df <- data.frame(matrix(ncol = length(r$columnHeaders$name) + 1, nrow = 0))
    colnames(df) <- c(r$columnHeaders$name, "playlist_id")
  } else {
    df <- as.data.frame(r$rows)
    colnames(df) <- c(r$columnHeaders$name)
    df["playlist_id"] <- playlist_id
  }

  df
}