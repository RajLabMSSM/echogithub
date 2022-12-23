test_that("github_workflows works", {
  
    repos <- c("orthogene","rworkflows")
    workflows <- "rworkflows"
    dt <- github_workflows(owner="neurogenomics", 
                           repo=repos, 
                           latest_only = TRUE,
                           workflows = workflows)
    testthat::expect_equal(repos, dt$repo)
    testthat::expect_equal(workflows, unique(dt$workflow))
})
