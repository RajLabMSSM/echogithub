r_repos_downloads_github <- function(pkgs,
                                     fields=NULL, 
                                     verbose=TRUE){
    github_url <- username <- package_name <- 
        downloads <- clones_count <-  NULL; 
    
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
            messager("Gathering GitHub downloads data with",
                     "githubinstall::gh_list_packages :",p,
                     v=verbose)    
            github_i <- subset(github, package_name==p)
            return(data.table::data.table(package=p,
                                          owner=github_i$username,
                                          repo=github_i$package_name))
        } else {
            messager("Gathering GitHub downloads data with",
                     "echogithub::description_extract :",p,
                     v=verbose)    
            tryCatch({ 
                description_extract(repo = p,
                                    fields = fields,
                                    as_datatable = TRUE,
                                    verbose = FALSE) |>
                    data.table::setnames("Package","package",
                                         skip_absent = TRUE)
            }, error=function(e){message(e);NULL})
        } 
    }) |> data.table::rbindlist(fill = TRUE)
    #### Remove those without owner/repo data####
    if(!all(c("owner","repo") %in% names(pkgs2))){
        messager("No GitHub downloads data retreived.",v=verbose)
        return(null_dt)
    }
    pkgs2 <- pkgs2[!is.na(owner) & !is.na(repo),]
    #### Check pkgs2 #####
    if(nrow(pkgs2)==0){
        messager("No GitHub downloads data retreived.",v=verbose)
        return(null_dt)
    }
    #### Get GitHub traffic metadata ####
    traffic <- lapply(seq_len(nrow(pkgs2)), function(i){
        tr <- github_traffic(owner = pkgs2[i,]$owner,
                             repo = pkgs2[i,]$repo,
                             verbose = verbose)
        if(!is.null(tr)) tr[,package:=(pkgs2[i,]$package)]
        return(tr)
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
