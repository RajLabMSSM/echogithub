test_that("github_traffic works", {
  
    dt <- github_traffic(owner="RajLabMSSM",
                         repo="echolocatoR")
    testthat::expect_true(methods::is(dt,"data.table"))
    testthat::expect_equal(nrow(dt),1)
})
