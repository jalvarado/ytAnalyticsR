library(testthat)

library(ytAnalyticsR)

library(httr)
httr_mock()

options("gargle_oauth_email" = TRUE)


test_that("it handles an empty response", {
  stub_registry_clear()
  empty_body <- '
  {
    "kind": "youtubeAnalytics#resultTable",
    "columnHeaders": [
      {
        "name": "day",
        "dataType": "STRING",
        "columnType": "DIMENSION"
      },
      {
        "name": "views",
        "dataType": "INTEGER",
        "columnType": "METRIC"
      }
    ],
    "rows": []
  }
  '
  stub_request("get",
  uri_regex = "https://youtubeanalytics.googleapis.com/v2/reports?ids=channel%3D%3DMINE&endDate=2022-01-01&dimensions=day&metrics=views&startDate=2022-01-01") %>%
    to_return(
      body = empty_body,
      status = 200,
      headers = list(
        'content-type' = 'application/json'
      )
    )

  result <- reports.query(
    metrics = "views",
    dimensions = "day",
    ids = "channel==MINE",
    startDate = "2022-01-01",
    endDate = "2022-01-01"
  )

  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_equal(colnames(result), c("day", "views"))
  testthat::expect_equal(nrow(result), 0)
})

test_that("it converts the response rows to a data.frame", {
  stub_registry_clear()
  empty_body <- '
  {
    "kind": "youtubeAnalytics#resultTable",
    "columnHeaders": [
      {
        "name": "day",
        "dataType": "STRING",
        "columnType": "DIMENSION"
      },
      {
        "name": "views",
        "dataType": "INTEGER",
        "columnType": "METRIC"
      }
    ],
    "rows": [
      ["2022-01-01", 100],
      ["2022-01-02", 250]
    ]
  }
  '
  stub_request("get",
  uri_regex = "https://youtubeanalytics.googleapis.com/v2/reports?ids=channel%3D%3DMINE&endDate=2022-01-02&dimensions=day&metrics=views&startDate=2022-01-01") %>%
    to_return(
      body = empty_body,
      status = 200,
      headers = list(
        'content-type' = 'application/json'
      )
    )

  result <- reports.query(
    metrics = "views",
    dimensions = "day",
    ids = "channel==MINE",
    startDate = "2022-01-01",
    endDate = "2022-01-02"
  )

  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_equal(colnames(result), c("day", "views"))
  testthat::expect_equal(nrow(result), 2)
})