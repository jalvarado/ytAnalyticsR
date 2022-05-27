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

response_to_data_frame <- function(r) {
  if (length(r$rows) == 0) {
    df <- data.frame(matrix(ncol = length(c(r$columnHeaders$name)), nrow = 0))
    colnames(df) <- c(r$columnHeaders$name)
  } else {
    df <- as.data.frame(r$rows)
    colnames(df) <- c(r$columnHeaders$name)
  }

  df
}

is_string <- function(x) length(x) == 1L && is.character(x)