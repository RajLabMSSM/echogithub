test_that("github_dependents works", {
  
    dt <- github_dependents(owner = "neurogenomics",
                            repo = "rworkflows")
    testthat::expect_true(methods::is(dt,"data.table"))
    testthat::expect_equal(ncol(dt),7)
    testthat::expect_gte(nrow(dt),10)
})
