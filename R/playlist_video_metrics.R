#' Get analytics data for all videos in the given playlist.
#'
#' @param channel_id Character containig the YouTube channel ID.
#' @param start_date Character containing the start date string. "YYYY-MM-DD"
#' @param end_date Character containing the end date string. "YYYY-MM-DD"
#' @param playlist_id Character playlist ID. Optional
#' @param playlist_title Character playlist title. Optional
#' @param metrics Character comma-separated list of metrics to fetch.
#' @param dimensions Character comma-separated list of dimensions.
#'
#' @export
playlist_video_metrics <- function(playlist_id,
                                   start_date,
                                   end_date,
                                   metrics = "views,likes,dislikes",
                                   dimensions = "day",
                                   sort = "day") {

  # Get all the videos from the playlist with their titles and ids
  videos <- get_playlist_videos(
    playlist_id,
    part = "snippet",
    simplify = TRUE,
    max_results = 51
  )[c("snippet.resourceId.videoId", "snippet.title")] %>%
    dplyr::rename(video_id = snippet.resourceId.videoId)

  video_metrics <- vvideo.query(
    video_id = videos$video_id,
    metrics = metrics,
    dimensions = dimensions,
    start_date = start_date,
    end_date = end_date,
    sort = sort
  )

  print(names(videos))
  print(names(video_metrics))
  data <- merge(videos,
                video_metrics,
                by = "video_id",
                all.x = TRUE)
  data
}
