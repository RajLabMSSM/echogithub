check_pkgs <- function(pkgs){
    if(is.character(pkgs)) pkgs <- data.table::data.table(package=pkgs)
    return(pkgs)
}