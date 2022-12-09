test_that("github_permissions works", {
  
    permissions <- github_permissions(owner="RajLabMSSM", 
                                      repo="echolocatoR")
    testthat::expect_true(is.list(permissions))
    testthat::expect_length(permissions,5)
})
