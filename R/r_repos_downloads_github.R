r_repos_downloads_github <- function(pkgs,
                                     fields=NULL, 
                                     multi_repos=FALSE,
                                     # Set to 2 for error messages in tryCatch
                                     verbose=TRUE){
    github_url <- username <- package_name <- 
        downloads <- clones_count <-  owner <- repo <- package <- NULL; 
    
    null_dt <- data.table::data.table(package=pkgs$package,
                                      downloads=NA)
    if(nrow(pkgs)==0) return(null_dt)
    #### Gather pre-computed GitHub info (from circa 2018) ####
    ghinstall <- (githubinstall::gh_list_packages() |> 
                   data.table::data.table()
    )[,github_url:=paste("https://github.com/",
                         username,package_name,sep="/")]
    ghinstall[,repo:=basename(github_url)]
    #### Get owner/repo names #### 
    #### Method 1: githubinstall ####
    ## Pre-compiled list of GitHub repos for each R package
    if(any(pkgs$package %in% ghinstall$package_name)){ 
        messager("Gathering GitHub downloads data with",
                 "githubinstall.",v=verbose)     
        ghinstall <- ghinstall[package_name %in% pkgs$package,
                             c("package_name","username","repo")]
        data.table::setnames(ghinstall,
                             c("package_name","username"),
                             c("package","owner")) 
        ### Can sometimes returns multiple repos per package,
        ### if the repo was renamed or transferred at some point  
        if(isFALSE(multi_repos)) {
            ghinstall <- ghinstall[,utils::head(.SD, 1), by="package"]
        } 
    } else{
        ghinstall <- data.table::data.table()
    }
    #### Method 2: echogithub ####
    ## Get remaining repos through DESCRIPTION file search
    if(!any(pkgs$package %in% ghinstall$package)){
        messager("Gathering GitHub downloads data with",
                 "echogithub",v=verbose)    
        echogh <- description_extract(refs = pkgs$package,
                                      fields = fields,
                                      as_datatable = TRUE,
                                      verbose = FALSE)
    } else {
        echogh <- data.table::data.table()
    }
    #### Combine methods ####
    pkgs2 <- data.table::rbindlist(list(ghinstall,echogh), fill = TRUE)
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
        tryCatch({
            tr <- github_traffic(owner = pkgs2[i,]$owner,
                                 repo = pkgs2[i,]$repo,
                                 verbose = verbose)
            if(!is.null(tr)) tr[,package:=(pkgs2[i,]$package)]
            return(tr)
        }, error=function(e){messager(e,v=verbose>1); NULL})
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
