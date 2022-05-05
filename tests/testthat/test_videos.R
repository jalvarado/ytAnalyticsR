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

  video_id <- "fake_video_id123"
  video_metrics <- video.query(video_id,
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(mock_reports_query, 1)
  testthat::expect_equal(nrow(video_metrics), 0)
  testthat::expect_s3_class(video_metrics, "data.frame")
})

testthat::test_that("api response rows are converted to dataframe rows", {
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
      ["value1", "value2"],
      ["value3", "value4"]
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
  testthat::expect_equal(video_metrics[[1]], c("value1", "value3"))
  testthat::expect_s3_class(video_metrics, "data.frame")
})

testthat::test_that("the video_id column is added to the data.frame", {
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
      ["value1", "value2"],
      ["value3", "value4"]
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
  testthat::expect_true(is.element("video_id", colnames(video_metrics)))
  testthat::expect_equal(video_metrics$video_id, c(video_id, video_id))
})

testthat::test_that("vvideo.query makes multiple calls to the api", {
  response_str1 <- '{
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
      ["value1", "value2"]
    ]
  }'
  response_str2 <- '{
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
      ["value3", "value4"]
    ]
  }'

  r1 <- jsonlite::fromJSON(response_str1)
  r2 <- jsonlite::fromJSON(response_str2)
  mock_responses <- mockery::mock(r1, r2)
  mockery::stub(vvideo.query, "reports.query", mock_responses, depth = 2)

  video_ids <- c("fake_video_id123", "totally_not_fake")
  video_metrics <- vvideo.query(video_ids,
    start_date = "2022-01-01",
    end_date = "2022-04-30",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(mock_responses, 2)
  testthat::expect_equal(nrow(video_metrics), 2)
  testthat::expect_s3_class(video_metrics, "data.frame")
  testthat::expect_equal(video_metrics$views, c("value1", "value3"))
})

testthat::test_that("vvideo.demographics calls vvideo.query for each id", {
  mock <- mockery::mock()
  mockery::stub(vvideo.demographics, "vvideo.query", mock)

  video_ids <- c("video_id_1", "video_id_2")

  results <- vvideo.demographics(video_ids,
    start_date = "2022-01-01",
    end_date = "2022-01-01"
  )
  args <- mockery::mock_args(mock)

  expected_args <- list(
    "video_id_1",
    "video_id_2",
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    metrics = "viewerPercentage",
    dimensions = "gender,ageGroup"
  )
  mockery::expect_called(mock, 1)
  testthat::expect_equal(args[[1]], expected_args)
})