infer_owner_repo <- function(owner,
                             repo,
                             pkg=NULL,
                             desc_file,
                             verbose=TRUE){
    #### Infer owner ####
    if(is.null(owner)){
        owner <- description_extract(fields = "owner",
                                     desc_file = desc_file,
                                     verbose = verbose)$owner
    }
    #### Infer repo ####
    if(is.null(repo)){
        repo <- description_extract(fields = "repo",
                                    desc_file = desc_file,
                                    verbose = verbose)$repo
    }
    #### Infer pkg ####
    ## Sometimes the package name is different from the repo name 
    if(is.null(repo)){
        pkg <- description_extract(fields = "Package",
                                   desc_file = desc_file,
                                   verbose = verbose)$Package
    }
    return(list(owner=owner,
                repo=repo,
                pkg=pkg))
}