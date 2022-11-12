test_that("github_branches works", {
  
    #### All branches ####
    branches1 <- github_branches(owner="RajLabMSSM", 
                                 repo="echolocatoR")
    testthat::expect_gte(length(branches1),2)
    #### Specific branch ####
    branches2 <- github_branches(owner="RajLabMSSM", 
                                 repo="echolocatoR",
                                 branch = "main")
    testthat::expect_equal(branches2,"master")
    
    #### Specific branch: without synonym matching ####
    testthat::expect_error(
        github_branches(owner="RajLabMSSM", 
                        repo="echolocatoR",
                        branch = "main",
                        master_or_main = FALSE)
    )
    #### Return data.table ####
    branches3 <- github_branches(owner="RajLabMSSM", 
                                 repo="echolocatoR",
                                 as_datatable = TRUE)
    testthat::expect_true(methods::is(branches3,"data.table"))
    
    #### Infer owner/repo ####
    ## Doesn't work with unit tests since those are done in a different dir
    # branches4 <- github_branches()
    # testthat::expect_equal(branches4,c("gh-pages","main"))
})
