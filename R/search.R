#' Search for playlists matching the given criteria.
#'
#' @param channel_id Character containing the YouTube channel ID. Used to limit
#' the search results to only playlists belonging to the specified channel.
#' @param title Character containing a playlist title to search for.  Will
#' only return exact matches and is case-sensitive.  Either \code{title} or
#' \code{q} parameter is retuired, but not both.
#' @param q Search term used to filter playlists by title.  Takes any regular
#' expression supported by \code{grepl}. Optional.
#' @param ... Additional parameters passed to \code{tuber::get_playlists}
#'
#' @importFrom dplyr tibble %>%
#' @importFrom tidyr unnest_wider
#'
#' @seealso [tuber::get_playlists()] for additional parameters
#' @seealso [grepl()] for regular expression requirements in the \code{q}
#' parameter
#'
#' @export
find_playlists <- function(channel_id = NULL,
                          title = NULL,
                          q = NULL,
                          ...) {
  # Either `title` or `q` must be provided.
  if (is.null(title) && is.null(q)) {
    stop("Either `title` or `q` must be provided, but not both.")
  }

  if (!is.null(title) && !is.null(q)) {
    stop("Either `title or `q` must be provided, but not both.")
  }


  # Check if we have authenticated with tubeR already
  if (!tuber::yt_authorized()) {
    print("No OAuth token found.  Please authorize using `yt_analytics_auth`.")
    yt_analytics_auth()
  }

  results <- dplyr::tibble()
  page_token <- NULL
  repeat {
    data <- tuber::get_playlists(
      filter = c(channel_id = channel_id),
      page_token = page_token
    )

    page_df <- dplyr::tibble(data = data$items) %>%
      dplyr::unnest_wider("data") %>%
      dplyr::unnest_wider("snippet") %>%
      dplyr::unnest_wider("id", names_sep = ".")

    results <- rbind(results, page_df)

    page_token <- data$nextPageToken
    # Check if we've reached the end of the available pages
    if (!is.character(page_token)) {
      break
    }
  }

  # Filter the results based on the q parameter
  if (!is.null(q)) {
    results <- results %>%
      dplyr::filter(grepl(q, .data$title, ignore.case = TRUE) |
        grepl(q, .data$description, ignore.case = TRUE))
  }

  return(results)
}
