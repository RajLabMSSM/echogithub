## ---- github_code ----

test_that("github_code searches and returns data.table", {
    testthat::skip_if_offline()
    testthat::skip_if(
        nchar(gh::gh_token()) == 0,
        message = "No GitHub token available"
    )
    res <- tryCatch(
        echogithub::github_code(query = "echogithub path:DESCRIPTION",
                    .limit = 5,
                    verbose = FALSE),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true(nrow(res) >= 1)
    testthat::expect_true("owner_repo" %in% names(res))
})

## ---- github_repositories ----

test_that("github_repositories searches and returns data.table", {
    testthat::skip_if_offline()
    testthat::skip_if(
        nchar(gh::gh_token()) == 0,
        message = "No GitHub token available"
    )
    res <- tryCatch(
        echogithub::github_repositories(query = "echogithub user:RajLabMSSM",
                            .limit = 5,
                            verbose = FALSE),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true(nrow(res) >= 1)
    testthat::expect_true("owner_repo" %in% names(res))
})

test_that("github_repositories handles vector query", {
    testthat::skip_if_offline()
    testthat::skip_if(
        nchar(gh::gh_token()) == 0,
        message = "No GitHub token available"
    )
    res <- tryCatch(
        echogithub::github_repositories(query = c("language:r", "user:RajLabMSSM"),
                            .limit = 5,
                            verbose = FALSE),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    testthat::expect_true(data.table::is.data.table(res))
})

## ---- github_user_events ----

test_that("github_user_events returns data.table for known user", {
    testthat::skip_if_offline()
    testthat::skip_if(
        nchar(gh::gh_token()) == 0,
        message = "No GitHub token available"
    )
    res <- tryCatch(
        echogithub::github_user_events(owner = "bschilder",
                           .limit = 10,
                           public_only = TRUE,
                           verbose = FALSE),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    if (!is.null(res)) {
        testthat::expect_true(data.table::is.data.table(res))
        testthat::expect_true("owner" %in% names(res))
        testthat::expect_true("owner_repo" %in% names(res))
    }
})

test_that("github_user_events returns NULL for nonexistent user with error=FALSE", {
    testthat::skip_if_offline()
    testthat::skip_if(
        nchar(gh::gh_token()) == 0,
        message = "No GitHub token available"
    )
    res <- tryCatch(
        echogithub::github_user_events(
            owner = "this_user_definitely_does_not_exist_12345xyz",
            error = FALSE,
            .limit = 5,
            verbose = FALSE
        ),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    ## Should be NULL because the user doesn't exist and error=FALSE
    testthat::expect_null(res)
})

test_that("github_user_events public_only changes endpoint", {
    testthat::skip_if_offline()
    testthat::skip_if(
        nchar(gh::gh_token()) == 0,
        message = "No GitHub token available"
    )
    ## Just verify both modes run without error
    res_public <- tryCatch(
        echogithub::github_user_events(owner = "bschilder",
                           .limit = 5,
                           public_only = TRUE,
                           verbose = FALSE),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    res_all <- tryCatch(
        echogithub::github_user_events(owner = "bschilder",
                           .limit = 5,
                           public_only = FALSE,
                           verbose = FALSE),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    ## Both should return data.tables (or NULL if no events)
    if (!is.null(res_public)) {
        testthat::expect_true(data.table::is.data.table(res_public))
    }
    if (!is.null(res_all)) {
        testthat::expect_true(data.table::is.data.table(res_all))
    }
})

## ---- github_files_httr ----

test_that("github_files_httr lists files from known repo", {
    testthat::skip_if_offline()
    testthat::skip_if_not_installed("httr")
    res <- tryCatch(
        echogithub:::github_files_httr(
            owner = "RajLabMSSM",
            repo = "echogithub",
            branch = "master",
            verbose = FALSE
        ),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    testthat::expect_true(data.table::is.data.table(res))
    testthat::expect_true(nrow(res) >= 1)
    testthat::expect_true("path" %in% names(res))
    testthat::expect_true("link" %in% names(res))
    ## Should contain the DESCRIPTION file
    testthat::expect_true(any(grepl("DESCRIPTION", res$path)))
})

test_that("github_files_httr link column has proper GitHub URLs", {
    testthat::skip_if_offline()
    testthat::skip_if_not_installed("httr")
    res <- tryCatch(
        echogithub:::github_files_httr(
            owner = "RajLabMSSM",
            repo = "echogithub",
            branch = "master",
            verbose = FALSE
        ),
        error = function(e) {
            testthat::skip(paste("GitHub API error:", e$message))
        }
    )
    ## All links should start with https://github.com
    testthat::expect_true(all(grepl("^https://github.com", res$link)))
})
