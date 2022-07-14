#' Retrieve playlist information
#'
#' @param playlist_id character; YouTube playlist ID used to uniquely identify
#' a playlist.
#' @param part Required.  One of the following: contentDetails, id,
#' localizations, player, snippet, status.  Default: snippet.
#' @param ... Additional parameters passed to \link{tuber::get_playlists}
#'
#' @return list
#'
#' @export
get_playlist_details <- function(playlist_id,
                                 part = "snippet",
                                 ...) {
  details <- tuber::get_playlists(
    filter = c(playlist_id = playlist_id),
    part = part,
    ...
  )

  details$items[[1]]
}
