testthat::test_that("video.query calls reports.query", {
  mock_data <- data.frame(views = c("foo", "row2"),
                          day = c("2022-01-01", "2022-01-02"))
  mock_reports_query <- mockery::mock(mock_data)
  mockery::stub(video.query, "reports.query", mock_reports_query)

  video_id <- "fake_video_id123"
  video_metrics <- video.query(video_id,
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(mock_reports_query, 1)
  testthat::expect_equal(nrow(video_metrics), 2)
})

testthat::test_that("an empty api response returns an empty dataframe", {
  mock_data <- data.frame(views = c(), day = c())
  mock_reports_query <- mockery::mock(mock_data)
  mockery::stub(video.query, "reports.query", mock_reports_query)

  video_id <- "fake_video_id123"
  video_metrics <- video.query(video_id,
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(mock_reports_query, 1)
  testthat::expect_equal(nrow(video_metrics), 0)
  testthat::expect_s3_class(video_metrics, "data.frame")
})

testthat::test_that("the video_id column is added to the data.frame", {
  mock_data <- data.frame(views = c(1, 0), day = c("2022-01-01", "2022-01-02"))
  mock_reports_query <- mockery::mock(mock_data)
  mockery::stub(video.query, "reports.query", mock_reports_query)

  video_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-01-02",
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

test_that("the video_id column is added to an empty dataframe response", {
  mock_data <- data.frame(views = NULL, day = NULL)
  expect_equal(nrow(mock_data), 0)
  mock_reports_query <- mockery::mock(mock_data)
  mockery::stub(video.query, "reports.query", mock_reports_query)

  video_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  video_id <- "fake_video_id123"
  video_metrics <- do.call(video.query, c(video_id, video_args))

  expect_true("video_id" %in% names(video_metrics))
  expect_equal(nrow(video_metrics), 0)
})

testthat::test_that("vvideo.query makes multiple calls to video.query", {
  video1 <- data.frame(views = c(1), day = c("2022-01-01"), video_id = c("fake_video_id123"))
  video2 <- data.frame(views = c(2), day = c("2022-01-01"), video_id = c("totally_not_fake"))
  mock <- mockery::mock(video1, video2)
  mockery::stub(vvideo.query, "video.query", mock)

  video_ids <- c("fake_video_id123", "totally_not_fake")
  video_metrics <- vvideo.query(video_ids,
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(mock, 2)
  testthat::expect_equal(nrow(video_metrics), 2)
  testthat::expect_s3_class(video_metrics, "data.frame")
  testthat::expect_equal(video_metrics$views, c(1, 2))
  testthat::expect_equal(video_metrics$video_id, video_ids)
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
