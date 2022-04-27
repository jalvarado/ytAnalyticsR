

testthat::test_that("video.query calls reports.query", {
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
  mock_reports_query <- mockery::mock(jsonlite::fromJSON(response_str))
  mockery::stub(video.query, "reports.query", mock_reports_query)

  video_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  video_id <- "fake_video_id123"
  video_metrics <- do.call(video.query, c(video_id, video_args))

  mockery::expect_called(mock_reports_query, 1)
  testthat::expect_equal(nrow(video_metrics), 2)
})

testthat::test_that("an empty api response returns an empty dataframe", {
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
  mock_reports_query <- mockery::mock(jsonlite::fromJSON(response_str))
  mockery::stub(video.query, "reports.query", mock_reports_query)

  video_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  video_id <- "fake_video_id123"
  video_metrics <- do.call(video.query, c(video_id, video_args))

  mockery::expect_called(mock_reports_query, 1)
  testthat::expect_equal(nrow(video_metrics), 0)
})