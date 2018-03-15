


getHousesCity <- function(city, is.df) {

  # remove warnings
  options(warn=-1)


  ############################################
  #
  # INITIAL PAGE
  #
  ############################################

  # Get the place id of the current city
  gp_id <- bnbScrap:::sqlSendQuery(sprintf("select * from city where name = '%s'", city)) %>% pull(gp_id)


  # Construct the url
  params.city <- sprintf("https://www.airbnb.pt/s/%s/homes?", city)
  weird.part.url <- paste0("refinement_paths%5B%5D=%2Fhomes&allow_override%5B%5D=&query=", city)
  place.id.url <- paste0('&place_id=', gp_id)
  url_city <- paste0(paste(params.city, weird.part.url, place.id.url, sep=""), '&tab_id=all_tab&s_tag=ZJlVVTab')

  # Structure containers
  timeframes <- c()
  ids.houses <- c()
  prices.houses <- c()

  # read the page
  webpage.url <- read_html(url_city)

  # get the timestamp
  timestamps <- Sys.time()

  # get the number of pages
  nbr.pages.class <- "._1am0dt"
  nbr.pages.str <- webpage.url %>% html_nodes(nbr.pages.class) %>% html_text() %>% as.integer() %<>% na.omit
  nbr.pages <- max(nbr.pages.str)

  # get the id
  id.houses.class <- "._1rp5252"
  current.id.houses <- webpage.url %>% html_nodes(id.houses.class) %>% html_attr("id")

  # get the price
  price.houses.class <- "._hylizj6"
  current.price.houses <- webpage.url %>% html_nodes(price.houses.class) %>% html_text()
  current.price.houses <- as.numeric(str_extract_all(current.price.houses, "[0-9]+")) %>% na.omit()

  # append the ids, prices and timeframes
  ids.houses <- c(ids.houses, current.id.houses)
  prices.houses <- c(prices.houses, current.price.houses)
  timeframes <- c(timeframes, rep(timestamps, length(current.id.houses)))


  cat("Initial page -- \n")
  cat(sprintf("Number of houses: %d \n", length(current.id.houses)))
  cat(sprintf("Number of prices %d \n \n", length(current.price.houses) ))




  ############################################
  #
  # OTHERS PAGE
  #
  ############################################

  # Add the base of the other url's
  base.other.url <- paste0(url_city, "&section_offset=")

  for (index.page in 1L:(nbr.pages-1)) {


    # construct the url for the next webpage to scrap
    current.url <- paste0(base.other.url, index.page)


    # get the current timestamps
    timestamps <- Sys.time()


    # Fetch the web page based on the url
    webpage.url <- read_html(current.url)


    # get the informations related to the ids houses and append it into the base
    current.id.houses <- webpage.url %>% html_nodes(id.houses.class) %>% html_attr("id")
    ids.houses <- c(ids.houses, current.id.houses)


    # get the informations related to the prices houses and append it into the base
    current.price.houses <- webpage.url %>% html_nodes(price.houses.class) %>% html_text()
    current.price.houses <- as.numeric(str_extract_all(current.price.houses, "[0-9]+")) %>% na.omit()
    prices.houses <- c(prices.houses, current.price.houses)


    # construct the timestamps
    timeframes <- c(timeframes, rep(timestamps, length(current.id.houses)))


    # advertize about the current pagination
    cat(sprintf("Current page: %d \n", index.page + 1))
    cat(sprintf("Number of houses: %d \n", length(current.id.houses)))
    cat(sprintf("Number of prices: %d \n", length(current.price.houses) ))
    cat(sprintf("Accumulated number of houses: %d \n\n", length(prices.houses)))

  }

  cat(sprintf("FINAL numbers: %d \n\n", length(prices.houses)))



  if (isTRUE(is.df)) {
    # build an object to return the whole informations and return it
    infos.city <- list( 'bnb_flat_id' = ids.houses,
                        'prices_houses' = prices.houses,
                        'timestamps' = timeframes ) %>% as.data.frame()
  } else {
    # build an object to return the whole informations and return it
    infos.city <- list( 'bnb_flat_id' = ids.houses,
                        'prices_houses' = prices.houses,
                        'timestamps' = timeframes )
    }

  return(infos.city)

}
