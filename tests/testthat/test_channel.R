library(testthat)

test_that("channel.query calls reports.query", {
  empty_mock <- mockery::mock()
  mockery::stub(channel.query, "reports.query", empty_mock)

  channel.query("fake_channel_1",
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  mockery::expect_called(empty_mock, 1)
})

test_that("channel.query returns a data.frame", {
  query_results <- data.frame(
    day = c("2022-01-01", "2022-01-02"),
    views = c("1", "12")
  )
  mockery::stub(channel.query, "reports.query", query_results)

  response <- channel.query("fake_channel_1",
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  expect_s3_class(response, "data.frame")
  expect_equal(nrow(response), 2)
  expect_equal(response$views, c("1", "12"))
})

test_that("channel.query handles an empty API response", {
  query_results <- data.frame(
    day = c(),
    views = c()
  )
  mockery::stub(channel.query, "reports.query", query_results)

  response <- channel.query("fake_channel_1",
    start_date = "2022-01-01",
    end_date = "2022-01-02",
    metrics = "views",
    dimensions = "day",
    sort = "day"
  )

  expect_s3_class(response, "data.frame")
  expect_equal(nrow(response), 0)
  expect_equal(response$views, c())
})

test_that("channel.demographics calls channel.query", {
  empty_mock <- mockery::mock()
  stub <- mockery::stub(channel.demographics, "channel.query", empty_mock)

  r <- channel.demographics("fake_channel_id",
    start_date = "2022-01-01",
    end_date = "2022-01-01"
  )

  expect_equal(length(empty_mock), 1)
  args <- mockery::mock_args(empty_mock)

  mockery::expect_called(empty_mock, 1)
  expect_equal(args[[1]], list("fake_channel_id",
    start_date = "2022-01-01",
    end_date = "2022-01-01",
    metric = "viewerPercentage",
    dimensions = "gender,ageGroup",
    sort = "gender,ageGroup"
  ))
})