test_that("r_repos_data works", {
  
    include <- c('echogithub', 'stats','gh','data.table')
    pkgs <- r_repos_data(include = include, 
                         add_downloads = TRUE, 
                         add_descriptions = TRUE)
    testthat::expect_true(all(pkgs$package %in% include))
    cols <- c("downloads","owner","repo","URL","Author","Title",
              "Description","Imports","Suggests")
    testthat::expect_true(all(cols %in% names(pkgs)))
})
