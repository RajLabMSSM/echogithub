test_that("github_commits works", {
  
    commits <- github_commits(owner="RajLabMSSM",
                            repo="echolocatoR")
    testthat::expect_true(methods::is(commits,"data.table"))
    testthat::expect_gte(nrow(commits), 420)
})
