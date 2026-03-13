sourcegraph_code <- function(){
    # curl \
    # -H 'Authorization: token <SOURCEGRAPH_TOKEN>' \
    # -d '{"query":"query { currentUser { username } }"}' \
    # https://sourcegraph.com/.api/graphql

    # context:global case:yes count:all fork:yes archived:yes content:"Package:" file:(?-i)^DESCRIPTION$

    # repo_api <-  "https://sourcegraph.com/.api/graphql"
    # #### Search ####
    # q <- list(
    #     Accept="text/event-stream",
    #     header="Authorization: token <access token>",
    #
    #     --url="https://sourcegraph.com/.api/graphql/search/stream",
    #     "data-urlencode"="q=<query>"
    # )
    # httr::timeout(seconds = seconds)
    # req <- httr::GET(repo_api)
    # httr::message_for_status(req)
    # filelist <- unlist(lapply(httr::content(req)$tree, "[", "path"),
    #                    use.names = FALSE
    # )

    # src search -json 'repogroup:sample error'  |> tmp.json
    # j <- jsonlite::read_json("~/Desktop/tmp.json",
    #                          simplifyDataFrame = TRUE)
    # d <- cbind(j$Results$repository,
    #            file_name=j$Results$file$name,
    #            file_url=j$Results$file$url,
    #      lapply(j$Results$lineMatches,function(x)x[1,]) |>
    #          data.table::rbindlist()
    #      )
    # d$package <- gsub("^Package:| |\n|\r","",d$preview)
    # length(unique(d$package))
    # sum(d$file_name!="DESCRIPTION")
    # sum(!grepl("^Package:*",d$preview))
    return(NULL)
}
