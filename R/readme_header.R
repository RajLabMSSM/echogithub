#' Create a README header
#' 
#' Create a header for your R package's README file,
#' containing hex stickers and \pkg{badger} badges.
#' @param add_hex Add a hex sticker with 
#' \link[echogithub]{github_hex}.
#' @param add_version Add package version with 
#' \link[badger]{badge_github_version}.
#' @param add_actions Add GitHub Actions status with
#' \link[badger]{badge_github_actions}.
#' @param add_commit Add the last GitHub repo commit date with
#' \link[badger]{badge_last_commit}.
#' @param add_codecov Add CodeCov status with
#' \link[badger]{badge_codecov}.
#' @param add_license Add license info with
#' \link[badger]{badge_license}.
#' @param add_authors Add author names inferred from 
#' the \code{DESCRIPTION} file.
#' @param as_list Return the header as a named list (\code{TRUE}), 
#' or a collapsed text string (default: \code{FALSE}).
#' @param sep Character to separate each item in the list with 
#' using \link[base]{paste}.
#' @inheritParams github_branches
#' @inheritParams github_files
#' @inheritParams github_hex
#' @inheritParams badger::badge_github_actions
#' 
#' @export
#' @importFrom gh gh_token 
#' @examples
#' \dontrun{
#'     h <- readme_header(owner = "RajLabMSSM",
#'                        repo = "echolocatoR")
#' }
readme_header <- function(owner = NULL,
                          repo = NULL,
                          token = gh::gh_token(),
                          desc_file = NULL,
                          verbose = TRUE,
                          branch = github_branches(
                              owner = owner,
                              repo = repo,
                              branch = "master",
                              token = token,
                              desc_file = desc_file,
                              verbose = FALSE),
                          add_hex = TRUE,
                          add_version = TRUE,
                          add_actions = TRUE,
                          add_commit = TRUE,
                          add_codecov = TRUE,
                          add_license = TRUE,
                          add_authors = TRUE,
                          hex_path = "inst/hex/hex.png",
                          action = "rworkflows",
                          height = 300,
                          as_list = FALSE,
                          sep = "\n"){
    
    # echoverseTemplate:::source_all()
    # echoverseTemplate:::args2vars(readme_header)
    
    requireNamespace("badger")
    
    desc_file <- description_find(desc_file = desc_file,
                                  verbose = verbose)
    out <- infer_owner_repo(owner = owner,
                            repo = repo,
                            desc_file = desc_file,
                            verbose = verbose)
    owner <- out$owner
    repo <- out$repo
    # pkg <- out$pkg
    ### badger has trouble finding the DESCRIPTION file in some cases
    ## help it out by adding it here.
    ref <- paste(owner,repo,sep="/")
    #### Construct list ####
    h <- list()
    if(isTRUE(add_hex)){
        h["hex"] <- github_hex(owner = owner,
                               repo = repo,
                               branch = branch,
                               desc_file = desc_file,
                               token = token,
                               hex_path = hex_path,
                               height = height,
                               verbose = verbose)
    }
    if(isTRUE(add_version)){
        messager("Adding version.",v=verbose)
        h["version"] <- badger::badge_github_version(color = 'black')
    }
    if(isTRUE(add_actions)){
        messager("Adding actions.",v=verbose)
        h["version"] <- badger::badge_github_actions(action = action)
    }
    if(isTRUE(add_commit)){
        messager("Adding commit.",v=verbose)
        h["commit"] <- badger::badge_last_commit(branch = branch)
    }
    if(isTRUE(add_codecov)){
        messager("Adding codecov.",v=verbose)
        h["codecov"] <- badger::badge_codecov(branch = branch)
    }
    if(isTRUE(add_license)){
        messager("Adding license.",v=verbose)
        h["license"] <-  badger::badge_license() 
    } 
    if(isTRUE(add_authors)){
        messager("Adding authors.",v=verbose)
        h["authors"] <- description_extract(repo = repo,
                                            desc_file = desc_file,
                                            fields = "authors",
                                            add_html = TRUE,
                                            verbose = verbose)
    }
    #### Return ####
    if(isTRUE(as_list)){
        return(h)
    } else {
        #### Add a break after the first item (usually hex sticker) ####
        hc <- paste(paste0(h[1],"<br><br>"),
                    paste(h[-1],collapse=sep), 
                    sep=sep) 
        cat(hc)
        return(hc)
    }
}

