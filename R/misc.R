#' A helper function that tests whether an object is either NULL _or_
#' a list of NULLs
#'
#' @keywords internal
is.NullOb <- function(x) is.null(x) | all(sapply(x, is.null))
#' Recursively step down into list, removing all such objects
#'
#' @keywords internal
rmNullObs <- function(x) {
  x <- Filter(Negate(is.NullOb), x)
  lapply(x, function(x) {
    if (is.list(x)) {
      rmNullObs(x)
    } else {
      x
    }
  })
}

#' Internal helpler function to parse the API response to a data.frame
#' and set the column names appropriately.
#'
#' @param r API response list from gargle::response_process
#'
#' @return data.frame parsed API response.
response_to_data_frame <- function(r) {
  headers <- lapply(r$columnHeaders, `[[`, "name")
  if (length(r$rows) == 0) {
    df <- data.frame(matrix(ncol = length(headers), nrow = 0))
  } else {
    df <- as.data.frame(do.call(rbind, r$rows))
  }
  colnames(df) <- headers
  df
}

is_string <- function(x) length(x) == 1L && is.character(x)
