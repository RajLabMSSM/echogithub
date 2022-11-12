test_that("github_hex works", {
  
    #### When a hex exists ####
    hex1 <- github_hex(owner = "RajLabMSSM",
                       repo = "echolocatoR")
    testthat::expect_equal(
        hex1,
        "<img src='https://github.com/RajLabMSSM/echolocatoR/raw/master/inst/hex/hex.png' height='300'>")
    
    #### When a hex DOES NOT exists ####
    hex2 <- github_hex(owner = "RajLabMSSM",
                       repo = "Fine_Mapping_Shiny")
    testthat::expect_null(hex2)
})
