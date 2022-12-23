r_repos_upset <- function(pkgs,
                          show_plot=TRUE,
                          save_path=tempfile(fileext = "upsetr.pdf"),
                          height=7,
                          width=10,
                          verbose = TRUE,
                          ...){
    requireNamespace("UpSetR")
    if(!is.null(save_path)) requireNamespace("grDevices")
    r_repo <- NULL;
    
    messager("Generating upset plot.",v=verbose)
    upsetr_data <- lapply(stats::setNames(unique(pkgs$r_repo),
                                          unique(pkgs$r_repo)),
                          function(r){
                              unique(subset(pkgs,r_repo==r)$package)
                          }) |> UpSetR::fromList()
    #### Plot ####
    upset_plot <- UpSetR::upset(data = upsetr_data,
                                nsets = 5*10,
                                nintersects = 40*10,
                                ...)
    #### Show ####
    if(isTRUE(show_plot)) methods::show(upset_plot)
    #### Save ####
    for(s in save_path){ 
        dir.create(dirname(s), showWarnings = FALSE, recursive = TRUE)
        ## PDF
        if(grepl(".png$",s, ignore.case = TRUE)){
            ## PNG
            messager("Saving plot ==>",s,v=verbose)
            grDevices::png(s, 
                           height = height, 
                           width = width, 
                           res = 300,
                           units = "in")
            methods::show(upset_plot)
            grDevices::dev.off()  
        } else if (grepl(".pdf$",s, ignore.case = TRUE)) {
            messager("Saving plot ==>",s,v=verbose)
            grDevices::pdf(s, onefile=FALSE,
                           height = height, 
                           width = width)
            methods::show(upset_plot)
            grDevices::dev.off() 
        } else {
            stp <- paste(
                "save_path must end with one of:",
                paste("\n -",c(".pdf",".png"),collapse = "")
            )
            stop(stp)
        }
    }
    #### Return ####
    return(list(data=upsetr_data,
                plot=upset_plot,
                save_path=save_path))
}

