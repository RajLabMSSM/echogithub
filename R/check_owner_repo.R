check_owner_repo <- function(owner,
                             repo,
                             verbose){ 
    
    if(length(owner)==length(repo)){
        return(list(owner=owner,
                    repo=repo))
    } else if(length(owner)==1 && length(repo)>1){
        messager("Assuming the same owner for all",length(repo),"repos.",
                 v=verbose)
        owner <- rep(owner,length(repo))
        #### Multiple owners, one repo ####
    } else if(length(owner)==1 && length(repo)>1){
        messager("Assuming the same repo for all",length(owner),"owners.",
                 v=verbose)
        repo <- rep(repo,length(owner))
    } else {
        stp <- paste(
            "owner and repo must have the same length",
            "or be of length 1 for one of these argments.")
        stop(stp)
    }
    return(list(owner=owner,
                repo=repo))
}
