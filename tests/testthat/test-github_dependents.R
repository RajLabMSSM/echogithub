test_that("github_dependents works", {
  
    dt <- github_dependents(owner = "neurogenomics",
                            repo = "rworkflows")
    cols <- c("target","owner","repo","stargazers_count","forks_count")
    testthat::expect_true(all(cols %in% names(dt)))
    testthat::expect_gte(nrow(dt),12)
})
