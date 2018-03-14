
#####################################################
# Send queries : SQLCommand("SELECT * FROM cartable")
#####################################################

sqlSendQuery <- function(query) {

  on.exit(dbDisconnect(con))
  con <- do.call( dbConnect,
                  c(drv = RPostgres:::Postgres(),
                    yaml.load_file("/Users/sofianembarki/Desktop/AIrbnb/config.yml")$db))

  tmp <- dbGetQuery(con, query)
  return(tmp)
}




