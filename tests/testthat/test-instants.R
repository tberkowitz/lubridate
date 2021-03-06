context("instants")

test_that("is.instant/is.timepoint works as expected",{
  expect_that(is.instant(234), is_false())
  expect_that(is.instant(as.POSIXct("2008-08-03 13:01:59", tz = "UTC")),
    is_true())
  expect_that(is.instant(as.POSIXlt("2008-08-03 13:01:59", tz = "UTC")), 
    is_true())
  expect_that(is.instant(Sys.Date()), is_true())
  expect_that(is.instant(minutes(1)), is_false())
  expect_that(is.timespan(interval(
    as.POSIXct("2008-08-03 13:01:59", tz = "UTC"), 
    as.POSIXct("2009-08-03 13:01:59", tz = "UTC") )), is_true())
})

test_that("is.instant/is.timepoint handle vectors",{
  expect_that(is.instant(minutes(1:2)), is_false())
  expect_that(is.instant(as.POSIXct(c("2008-08-03 13:01:59", 
  	"2008-08-03 13:01:59"), tz = "UTC")), is_true())
})

test_that("now() handles time zone input correctly",{
  expect_identical(floor_date(now("UTC"), "minute"), floor_date(as.POSIXct(format(
    as.POSIXct(Sys.time()), tz = "UTC"), tz = "UTC"), "minute"))
})

test_that("today() works correctly",{
  expect_identical(today(), Sys.Date())
})


test_that("make_datetime returns same values as ISOdatetime", {

  set.seed(1000)
  
  N <- 1e4
  y <- as.integer(runif(N, 1800, 2200))
  m <- as.integer(runif(N, 1, 12))
  d <- as.integer(runif(N, 1, 28))
  H <- as.integer(runif(N, 0, 23))
  M <- as.integer(runif(N, 0, 59))
  S <- runif(N, 0, 59)

  out1 <- ISOdatetime(y, m, d, H, M, S, tz = "UTC")
  out2 <- make_datetime(y, m, d, H, M, S)
  expect_equal(out1, out2)

  S <- as.integer(runif(N, 0, 59))

  out1 <- ISOdatetime(y, m, d, H, M, S, tz = "UTC")
  out2 <- make_datetime(y, m, d, H, M, S)
  expect_equal(out1, out2)
})

test_that("make_datetime replicates as expected", {
  expect_equal(make_datetime(year = 1999, month = c(11, 12), day = 22, sec = c(10, 11)),
               as.POSIXct(c("1999-11-22 00:00:10 UTC", "1999-12-22 00:00:11 UTC"), tz = "UTC"))
})

test_that("make_datetime propagates NAs as expected", {
  expect_equal(make_datetime(year = 1999, month = c(11, NA), day = 22, sec = c(10, 11, NA)), 
               as.POSIXct(c("1999-11-22 00:00:10 UTC", NA, NA), tz = "UTC"))
})
