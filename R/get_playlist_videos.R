#' Get all videos in the given playlist
#'
#' @param playlist_id Character containing the YouTube playlist ID.
#' @inheritDotParams tuber::get_playlist_items -filter
#'
#' @importFrom tuber get_playlist_items
#'
#' @seealso [tuber::get_playlist_items()] for additional arguments
#' @export
get_playlist_videos <- function(playlist_id, ...) {
  tuber::get_playlist_items(
    filter = c(playlist_id = playlist_id),
    ...
  )
}
