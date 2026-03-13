test_that("github_traffic works", {

    testthat::skip_if_offline()

    dt <- tryCatch(
        github_traffic(owner="RajLabMSSM",
                       repo="echolocatoR"),
        error = function(e) NULL
    )
    ## Traffic API requires admin/push access which
    ## GITHUB_TOKEN in GHA may not have.
    testthat::skip_if(is.null(dt),
                      "github_traffic requires repo admin access")
    testthat::expect_true(methods::is(dt,"data.table"))
    testthat::expect_equal(nrow(dt), 1)
})
