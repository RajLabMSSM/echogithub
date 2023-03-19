test_that("r_repos works", {
  
    #### Setup ####
    save_path <- tempfile(fileext = c("upset.pdf","upset.png")) 
    run_tests <- function(report,
                          repos,
                          save_path){ 
        testthat::expect_true(
            all(repos %in% unique(report$pkgs$r_repo))
        )
        testthat::expect_true(
            all(repos %in% report$repo_stats$r_repo)
        )
        testthat::expect_true(methods::is(report$upset$plot,"upset"))
        testthat::expect_true(all(
            file.exists(save_path)
        ))
    }
    #### All packages, all repos ####
    save_path <- file.path(tempdir(),c("upsetr.pdf","upsetr.png"))
    repos <- r_repos_opts()
    report <- r_repos(save_path = save_path, 
                      which = repos)  
    testthat::expect_gte(length(unique(report$pkgs$package)),49000)
    run_tests(report=report,
              repos=repos,
              save_path=save_path)
    
    #### All packages, without repos GitHub/local
    save_path2 <- file.path(tempdir(),c("upsetr2.pdf","upsetr2.png"))
    repos2 <- r_repos_opts(exclude=c("GitHub","local"))
    report2 <- r_repos(save_path = save_path2,
                       which = repos2, 
                       add_downloads = TRUE)
    testthat::expect_gte(length(unique(report2$pkgs$package)),24000)
    run_tests(report=report2,
              repos=repos2,
              save_path=save_path2)
    
})
