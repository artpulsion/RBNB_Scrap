
#####################################################
# Send queries : sqlSendQuery("SELECT * FROM cartable")
#####################################################

sqlSendQuery <- function(query) {

  on.exit(dbDisconnect(con))
  con <- do.call( dbConnect,
                  c(drv = RPostgres:::Postgres(),
                    yaml.load_file("/Users/sofianembarki/Desktop/bnbProject/bnbScrap/config/config.yml")$db))

  tmp <- dbGetQuery(con, query)
  return(tmp)
}




