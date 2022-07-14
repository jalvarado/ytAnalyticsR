#' Fetch video details from the YouTube Data API
#'
#' @inheritParams tuber::get_video_details
#'
#' @return list
#' @export
get_video_details <- function(video_id = NULL, part = "snippet", ...) {
  tuber::get_video_details(video_id, part, ...)
}
