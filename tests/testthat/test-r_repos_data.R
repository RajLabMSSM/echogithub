test_that("r_repos_data works", {
  
    include <- c('echogithub', 'stats','gh','data.table')
    pkgs <- r_repos_data(include = include, 
                         add_downloads = TRUE, 
                         add_descriptions = TRUE,
                         add_github = TRUE)
    testthat::expect_equal(sort(unique(pkgs$package), na.last = TRUE),
                           sort(include))
    
    cols <- c('package','owner','repo','authors',
              'github_url','r_repo','installed','downloads',
              "forks_count","permissions")
    testthat::expect_true(all(cols %in% names(pkgs))) 
})
