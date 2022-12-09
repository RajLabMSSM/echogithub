test_that("github_metadata works", {
  
    dt <- github_metadata(owner="RajLabMSSM",
                          repo="echolocatoR")
    testthat::expect_true(methods::is(dt,"data.table"))
    testthat::expect_gte(ncol(dt), 90)
})
