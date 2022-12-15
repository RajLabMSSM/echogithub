test_that("multiplication works", {
  
    pkgs <- r_repos_data()[r_repo=="CRAN",][seq_len(5),]
    pkgs2 <- r_repos_downloads(pkgs = pkgs)
    testthat::expect_true(all(pkgs$package %in% pkgs2$package))
    cols <- c("package","r_repo","downloads")
    testthat::expect_true(all(cols %in% names(pkgs2)))
})
