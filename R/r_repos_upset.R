r_repos_upset <- function(pkgs,
                          save_path=tempfile(pattern = "upsetr.pdf"),
                          verbose = TRUE,
                          ...){
    requireNamespace("UpSetR")
    repo <- NULL;
    
    messager("Generating upset plot.",v=verbose)
    upsetr_data <- lapply(stats::setNames(unique(pkgs$repo),
                                          unique(pkgs$repo)),
                          function(r){
                              unique(subset(pkgs,repo==r)$package)
                          }) |> UpSetR::fromList()
    #### Plot ####
    upset_plot <- UpSetR::upset(data = upsetr_data,
                                ...)
    #### Save ####
    if(!is.null(save_path)){
        requireNamespace("grDevices")
        ## PDF
        if(endsWith(save_path,".png")){
            ## PNG
            grDevices::png(save_path)
            upset_plot
            grDevices::dev.off()  
        } else {
            grDevices::pdf(save_path)
            upset_plot
            grDevices::dev.off() 
        }
    }
    #### Return ####
    return(list(data=upsetr_data,
                plot=upset_plot))
}
