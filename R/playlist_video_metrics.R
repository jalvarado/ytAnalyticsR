#' Get analytics data for all videos in the given playlist.
#'
#' @param playlist_id Character containig the YouTube playlist ID.
#' @param playlist_title Character playlist title. Optional
#' @param start_date Character containing the start date string. "YYYY-MM-DD"
#' @param end_date Character containing the end date string. "YYYY-MM-DD"
#' @param metrics Character comma-separated list of metrics to fetch.
#' @param dimensions Character comma-separated list of dimensions.
#'
#' @export
playlist_video_metrics <- function(playlist_id,
                                   start_date,
                                   end_date,
                                   playlist_title = NULL,
                                   metrics = "views,likes,dislikes",
                                   dimensions = "day") {
  if (is.null(playlist_id) && is.null(playlist_title)) {
    stop("Either `playlist_id` or `playlist_title` is required.")
  }

  if (!is.null(playlist_id) && !is.null(playlist_title)) {
    stop("Both `playlist_id` and `playlist_title` should not be set.
      Please use one or the other.")
  }

  if (is.character(playlist_title)) {
    results <- tuber::yt_search(term = playlist_title, type = "playlist")
  }
}
