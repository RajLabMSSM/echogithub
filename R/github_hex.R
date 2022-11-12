#' GitHub hex
#' 
#' Find the URL to a hex sticker for an R package in a GitHub repository.
#' If none can be found, returns \code{NULL}.
#' @param hex_path Path to the hex sticker in the GitHub repo.
#' @param add_html Wrap the URL in HTML syntax (i.e. "<img src=...").
#' @param height Height of the HTML image (only used when \code{add_html=TRUE}).
#' @inheritParams github_branches
#' @returns URL to hex sticker.
#' 
#' @export 
#' @importFrom gh gh_token
#' @examples 
#' hex <- github_hex(owner="RajLabMSSM", repo="echolocatoR")
github_hex <- function(owner = NULL,
                       repo = NULL,
                       branch = "master",
                       master_or_main = TRUE,
                       hex_path = "inst/hex/hex.png",
                       desc_file = NULL,
                       add_html = TRUE,
                       height = 300,
                       token = gh::gh_token(),
                       verbose=TRUE){
    
    out <- infer_owner_repo(owner = owner,
                            repo = repo,
                            desc_file = desc_file,
                            verbose = verbose)
    owner <- out$owner
    repo <- out$repo 
    
    dt <- github_branches(owner = owner, 
                          repo = repo, 
                          branch = branch,
                          master_or_main = master_or_main,
                          as_datatable = TRUE,
                          token = token, 
                          verbose = verbose)[1,]
    #### Construct URL ####
    hex_url <- paste(
        "https://github.com",dt$owner,dt$repo,
        "raw",dt$name,hex_path,sep="/"
    )
    if(isTRUE(is_url(hex_url))){
        messager("Valid hex URL found:",hex_url,v=verbose)
    } else {
        messager("Hex URL cannot be found. Returning NULL.",v=verbose)
        return(NULL)
    }
    #### Add HTML formatting ####
    if(isTRUE(add_html)){
        hex_url <- paste(paste0("<img src=",shQuote(hex_url)),
                         paste0("height=",shQuote(height),">"))
    }
    return(hex_url)
}
