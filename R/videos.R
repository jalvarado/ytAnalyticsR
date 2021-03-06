#' Query the Analytics API and retrieve metrics for the given video id
#'
#' @param video_id YouTube video id string
#' @param metrics string of comma separated metric names to query
#' @param dimensions string of comma separated dimenension names
#' @param filters string of semi-colon separated filters to apply to the query
#' @param start_date date string in 'YYYY-mm-dd' format
#' @param end_date date string in 'YYYY-mm-dd' format
#' @param sort string of comma separated list of dimensions to sort by.  Prepend
#'   the dimension name with '-' to sort descending
#' @param ids string of semi-colon separated id terms.  i.e. 'channel==MINE'
#'
#' @return data.frame
#'
#' @export
video.query <- function(video_id, metrics = NULL, filters = NULL,
                        start_date = NULL, end_date = NULL, dimensions = NULL,
                        sort = NULL, ids = c("channel==MINE")) {
  query_filters <- paste(
    paste0("video==", video_id),
    filters,
    sep = ";"
  )

  data <- reports.query(
    startDate = start_date,
    endDate = end_date,
    metrics = metrics,
    dimensions = dimensions,
    filters = query_filters,
    ids = ids
  )

  if (nrow(data) == 0) {
    df <- data.frame(matrix(ncol = length(names(data)) + 1, nrow = 0))
    colnames(df) <- c(names(data), "video_id")
  } else {
    df <- data
    df$video_id <- video_id
  }
  return(df)
}

#' Query the Analytics API and retrieve demographics information
#'
#' @param video_id YouTube video ID string
#' @param filters string of semi-colon separated filters to apply to the query
#' @param start_date date string in 'YYYY-mm-dd' format
#' @param end_date date string in 'YYYY-mm-dd' format
#' @param sort string of comma separated list of dimensions to sort by.  Prepend
#'   the dimension name with '-' to sort descending
#' @param ids string of semi-colon separated
#'
#' @return data.frame
#'
#' @export
video.demographics <- function(video_id, start_date, end_date,
                               filters = NULL, sort = "ageGroup,gender",
                               ids = "channel==MINE") {
  api_args <- list(
    startDate = start_date,
    endDate = end_date,
    ids = ids,
    filters = filters,
    metric = "viewerPercentage",
    dimensions = "gender,ageGroup",
    sort = sort
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

#' Query the Analytics API and retrieve metrics for the given video ids
#'
#' @param video_ids vector of YouTube video id strings
#' @inheritDotParams video.query -video_id
#'
#' @return data.frame
#' @seealso [video.query()]
#'
#' @export
vvideo.query <- function(video_ids, ...) {
  dfs <- lapply(video_ids, function(id) video.query(id, ...))
  do.call(what = rbind, args = dfs)
}

#' Query the Analytics API and retrieve metrics for the given video ids
#'
#' @param video_ids vector of YouTube video id strings
#' @inheritDotParams video.query -video_id
#'
#' @return data.frame
#' @seealso [video.query()]
#'
#' @family videos
#'
#' @export
vvideo.demographics <- function(video_ids, ...) {
  fargs <- list(...)
  fargs$metrics <- "viewerPercentage"
  fargs$dimensions <- "gender,ageGroup"

  do.call(vvideo.query, c(video_ids, fargs))
}
