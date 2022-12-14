test_that("r_repos works", {
  
    report <- r_repos()
    repos <- c("base","CRAN","Bioc","rOpenSci","GitHub")
    testthat::expect_gte(nrow(report$pkgs),50000)
    testthat::expect_true(all(repos %in% unique(report$pkgs$repo)))
    testthat::expect_true(all(repos %in% report$repo_stats$repo))
    testthat::expect_true(methods::is(report$upset$plot,"upset"))
})
