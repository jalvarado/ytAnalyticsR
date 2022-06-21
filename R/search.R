#' Search YouTube for a playlist
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
find_playlist <- function(channel_id = NULL,
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

  data <- tuber::get_playlists(filter = c(channel_id = channel_id))

  next_page_token <- data$nextPageToken
  print(next_page_token)

  results <- tibble(data = data$items) %>%
    unnest_wider("data") %>%
    unnest_wider("snippet") %>%
    unnest_wider("id", names_sep = ".")

  # Paginate through the API responses
  while (is.character(next_page_token)) {
    print(paste0("Fetching page: ", next_page_token))
    data <- tuber::get_playlists(
      filter = c(channel_id = channel_id),
      page_token = next_page_token
    )
    next_page_token <- data$nextPageToken

    df <- tibble(data = data$items) %>%
      unnest_wider("data") %>%
      unnest_wider("snippet") %>%
      unnest_wider("id", names_sep = ".")

    results <- rbind(results, df)
  }

  # Filter the results based on the q parameter
  if (!is.null(q)) {
    results <- results %>%
      dplyr::filter(grepl(q, title, ignore.case = TRUE) |
        grepl(q, description, ignore.case = TRUE))
  }

  return(results)
}
