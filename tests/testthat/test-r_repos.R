test_that("r_repos works", {
  
    #### Setup ####
    save_path <- tempfile(fileext = c("upset.pdf","upset.png"))
    save_path <- file.path("~/Downloads",c("upsetr.pdf","upsetr.png"))
    repos <- r_repos_opts()
    #### Run ####
    report <- r_repos(save_path = save_path)
    #### Tests ####
    testthat::expect_gte(nrow(report$pkgs),50000)
    testthat::expect_true(
        all(tolower(repos) %in% tolower(gsub("-","",unique(report$pkgs$r_repo))))
    )
    testthat::expect_true(
        all(tolower(repos) %in% tolower(gsub("-","",unique(report$repo_stats$r_repo))))
    )
    testthat::expect_true(methods::is(report$upset$plot,"upset"))
    testthat::expect_true(all(
        file.exists(save_path)
    ))
})
