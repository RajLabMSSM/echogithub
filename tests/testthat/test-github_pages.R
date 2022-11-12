test_that("github_pages works", {
  
    #### Real repo ####
    link <- github_pages(owner="RajLabMSSM", 
                         repo="echolocatoR")
    testthat::expect_equal(link,"https://rajlabmssm.github.io/echolocatoR/")
    
    #### typo ####
    testthat::expect_error(
        github_pages(owner="RajLabMSSM", repo="echolocatoRRRRRR")
    )
    #### typo with error=FALSE ####
    link2 <- github_pages(owner="RajLabMSSM", 
                          repo="echolocatoRRRRRR", 
                          error = FALSE)
    testthat::expect_null(link2)
})
