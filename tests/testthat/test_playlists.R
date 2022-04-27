library(testthat)
library(ytAnalyticsR)

testthat::test_that("Response rows are converted to dataframe rows", {
  response_str <- '{
    "kind": "youtubeAnalytics#resultTable",
    "columnHeaders": [
      {
        "name": "views",
        "dataType": "STRING",
        "columnType": "METRIC"
      },
      {
        "name": "day",
        "dataType": "STRING",
        "columnType": "DIMENSION"
      }
    ],
    "rows": [
      ["foo", "bar"],
      ["row2", "fake_data"]
    ]
  }'
  api_response <- jsonlite::fromJSON(response_str)
  mockery::stub(playlists.query, "reports.query", api_response)

  playlist_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  playlist_id <- "fake_playlist_id"
  playlist_metrics <- do.call(playlists.query, c(playlist_id, playlist_args))

  testthat::expect_equal(nrow(playlist_metrics), 2)
})

testthat::test_that("Response column headers are mapped to column names", {
  # Empty API response
  response_str <- '{
    "kind": "youtubeAnalytics#resultTable",
    "columnHeaders": [
      {
        "name": "views",
        "dataType": "STRING",
        "columnType": "METRIC"
      },
      {
        "name": "day",
        "dataType": "STRING",
        "columnType": "DIMENSION"
      }
    ],
    "rows": []
  }'
  api_response <- jsonlite::fromJSON(response_str)
  mockery::stub(playlists.query, "reports.query", api_response)

  playlist_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  playlist_id <- "fake_playlist_id"
  playlist_metrics <- do.call(playlists.query, c(playlist_id, playlist_args))

  testthat::expect_equal(
    c("views", "day", "playlist_id"),
    colnames(playlist_metrics)
  )
  testthat::expect_equal(nrow(playlist_metrics), 0)
})

test_that("An empty API response results in an empty data.frame", {
  # Empty API response
  response_str <- '{
    "kind": "youtubeAnalytics#resultTable",
    "columnHeaders": [
      {
        "name": "views",
        "dataType": "STRING",
        "columnType": "METRIC"
      },
      {
        "name": "day",
        "dataType": "STRING",
        "columnType": "DIMENSION"
      }
    ],
    "rows": []
  }'
  api_response <- jsonlite::fromJSON(response_str)
  mockery::stub(playlists.query, "reports.query", api_response)

  playlist_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  playlist_id <- "fake_playlist_id"
  playlist_metrics <- do.call(playlists.query, c(playlist_id, playlist_args))

  testthat::expect_equal(nrow(playlist_metrics), 0)
})