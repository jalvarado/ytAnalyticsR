library(testthat)
library(ytAnalyticsR)

test_that("Response rows are converted to dataframe rows", {
  query_results <- data.frame(
    day = c("2022-01-01", "2022-01-02"),
    views = c("1", "12")
  )
  mockery::stub(playlists.query, "reports.query", query_results)

  playlist_id <- "fake_playlist_id"
  playlist_metrics <- playlists.query(playlist_id,
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  testthat::expect_equal(nrow(playlist_metrics), 2)
})

test_that("playlist_id is added to the dataframe", {
  query_results <- data.frame(
    day = c("2022-01-01", "2022-01-02"),
    views = c("1", "12")
  )
  mockery::stub(playlists.query, "reports.query", query_results)

  playlist_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  playlist_id <- "fake_playlist_id"
  playlist_metrics <- do.call(playlists.query, c(playlist_id, playlist_args))

  expected_df <- data.frame(
    day = c("2022-01-01", "2022-01-02"),
    views = c("1", "12"),
    playlist_id = c(playlist_id, playlist_id)
  )

  expect_identical(playlist_metrics, expected_df)
})

test_that("Response column headers are mapped to column names", {
  query_results <- data.frame(matrix(ncol = 2, nrow = 0))
  colnames(query_results) <- c("day", "views")
  mockery::stub(playlists.query, "reports.query", query_results)

  playlist_args <- list(
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )
  playlist_id <- "fake_playlist_id"
  playlist_metrics <- do.call(playlists.query, c(playlist_id, playlist_args))

  testthat::expect_equal(
    colnames(playlist_metrics),
    c("day", "views", "playlist_id")
  )
  testthat::expect_equal(nrow(playlist_metrics), 0)
})

test_that("An empty API response results in an empty data.frame", {
  query_results <- data.frame(matrix(ncol = 2, nrow = 0))
  colnames(query_results) <- c("day", "views")
  mockery::stub(playlists.query, "reports.query", query_results)

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

test_that("vplaylist.query makes multiple calls to playlist.query", {
  empty_df <- data.frame(matrix(ncol = 3, nrow = 0))
  colnames(empty_df) <- c("views", "day", "playlist_id")

  empty_mock <- mockery::mock(empty_df, empty_df)
  mockery::stub(vplaylist.query, "playlists.query", empty_mock)

  playlist_ids <- c("fake_playlist_id_1", "fake_playlist_id_2")
  results <- vplaylist.query(playlist_ids,
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(empty_mock, 2)
})

test_that("vplaylist.query returns a unified data.frame", {
  r1 <- data.frame(
    views = c(100), day = c("2022-01-01"),
    playlist_id = c("fake_playlist_id_1")
  )
  r2 <- data.frame(
    views = c(102), day = c("2022-01-01"),
    playlist_id = c("fake_playlist_id_2")
  )
  playlist_mock <- mockery::mock(r1, r2)
  mockery::stub(vplaylist.query, "playlists.query", playlist_mock)

  playlist_ids <- c("fake_playlist_id_1", "fake_playlist_id_2")
  results <- vplaylist.query(playlist_ids,
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  testthat::expect_equal(nrow(results), 2)
  testthat::expect_equal(results$playlist_id, playlist_ids)
})

test_that("playlist.demographics calls playlist.query", {
  empty_df <- data.frame(matrix(ncol = 4, nrow = 0))
  colnames(empty_df) <- c(
    "viewerPercentage", "gender",
    "ageGroup", "playlist_id"
  )

  empty_mock <- mockery::mock(empty_df)
  mockery::stub(playlist.demographics, "playlists.query", empty_mock)

  playlist_id <- "fake_playlist_id"
  results <- playlist.demographics(playlist_id,
    start_date = "2022-01-01",
    end_date = "2022-01-01"
  )

  mockery::expect_called(empty_mock, 1)
  mockery::expect_args(empty_mock, 1, playlist_id,
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    ids = "channel==MINE",
    metric = "viewerPercentage",
    dimensions = "gender,ageGroup",
    sort = "gender,ageGroup"
  )
})