test_that("github_pages_files works", {
    
    #### Test echolocatoR #####
    dt <-  github_pages_files(owner = "RajLabMSSM",
                              repo = "echolocatoR") 
    testthat::expect_gte(nrow(dt), 20)
    
    #### Test Fine_Mapping repo #### 
    links_df <- github_pages_files(owner = "RajLabMSSM",
                                   repo = "Fine_Mapping",
                                   branch = "master")
    testthat::expect_gte(nrow(links_df), 220)
})
