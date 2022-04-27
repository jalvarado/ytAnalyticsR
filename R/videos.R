#' Query the Analytics API and retrieve metrics for the given video id
#'
#' @export
video.query <- function(video_id, metrics = NULL, filters = NULL,
                        start_date = NULL, end_date = NULL, dimensions = NULL,
                        sort = NULL, ids = c("channel==MINE")) {
  video_filter <- paste0("video==", video_id)

  if (is.null(filters)) {
    all_filters <- video_filter
  } else {
    all_filters <- paste(filters, video_filter, sep = ";")
  }

  api_args <- list(
    metrics = metrics, filters = all_filters,
    startDate = start_date, endDate = end_date,
    dimensions = dimensions, sort = sort, ids = ids
  )
  r <- do.call(reports.query, rmNullObs(api_args))

  if (length(r$rows) == 0) {
    df <- data.frame(matrix(ncol = length(r$columnHeaders$name) + 1, nrow = 0))
    colnames(df) <- c(r$columnHeaders$name, "video_id")
  } else {
    df <- as.data.frame(r$rows)
    colnames(df) <- c(r$columnHeaders$name)
    df["video_id"] <- video_id
  }

  df
}

vvideo.query <- function(video_ids, ...) {
  dfs <- list()
  for (i in length(video_ids)) {
    video_id <- video_ids[[i]]
    dfs[i] <- video.query(video_id, ...)
  }
  do.call(what = rbind, args = dfs)
}