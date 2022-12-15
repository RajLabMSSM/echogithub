r_repos_downloads_github <- function(pkgs,
                                     verbose=TRUE){
    github_url <- username <- package_name <- 
        downloads <- clones_count <-  NULL;

    messager("Gathering GitHub downloads data.",v=verbose)    
    null_dt <- data.table::data.table(package=pkgs$package,
                                      downloads=NA)
    if(nrow(pkgs)==0) return(null_dt)
    #### Gather pre-computed GitHub info (from circa 2018) ####
    github <- (githubinstall::gh_list_packages() |> 
                   data.table::data.table()
    )[,github_url:=paste("https://github.com/",
                         username,package_name,sep="/")]
    #### Get owner/repo names for each package ####
    pkgs2 <- lapply(pkgs$package, function(p){
        if(p %in% github$package_name){ 
            github_i <- subset(github, package_name==p)
            return(data.table::data.table(package=p,
                                          owner=github_i$username,
                                          repo=github_i$package_name))
        } else {
            tryCatch({
                d <- description_find(repo = p,
                                      verbose = FALSE)
                res <-  description_extract(desc_file = d, 
                                            fields = c("owner","repo"),
                                            verbose = FALSE)
                data.table::data.table(package=p,
                                       owner=res$owner,
                                       repo=res$repo,)
            }, error=function(e){NULL})
        } 
    }) |> data.table::rbindlist(fill = TRUE)
    #### Get GitHub traffic metadata ####
    traffic <- lapply(seq_len(nrow(pkgs2)), function(i){
        github_traffic(owner = pkgs2[i,]$owner,
                       repo = pkgs2[i,]$repo,
                       verbose = verbose)
    }) |> data.table::rbindlist(fill=TRUE)
    #### Check for empty data ####
    if(nrow(traffic)>0) {
        traffic[,downloads:=clones_count]
    } else {
        traffic <- null_dt
    }
    #### Return ####
    return(traffic) 
}
