
###################################################################
# Write data :SQLWriteValues(data.frame, "table we want to target")
###################################################################

sqlWriteValues <- function(values, table) {

  on.exit(dbDisconnect(con))
  con <- do.call( dbConnect,
                  c(drv = dbDriver("PostgresSQL"),
                    yaml.load_file("/Users/sofianembarki/Desktop/AIrbnb/config.yml")$db))

  dbWriteTable(con, table, value = values, append = T, row.names = F)
  return(NULL)
}


