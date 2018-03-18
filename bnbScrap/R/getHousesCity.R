


getHousesCity <- function(city, is.df) {


  ############################################
  ############################################
  #               INITIAL PAGE
  ############################################
  ############################################


  # Get the place id of the current city
  gp_id <- bnbScrap:::sqlSendQuery(sprintf("SELECT gp_id FROM city WHERE name = '%s'", city)) %>% pull(.)

  # Construct the url
  params.city <- sprintf("https://www.airbnb.pt/s/%s/homes?", city)
  weird.part.url <- paste0("refinement_paths%5B%5D=%2Fhomes&allow_override%5B%5D=&query=", city)
  place.id.url <- paste0('&place_id=', gp_id)
  url_city <- paste0(paste(params.city, weird.part.url, place.id.url, sep=""), '&tab_id=all_tab&s_tag=ZJlVVTab')

# --------

  # Create the structure we use to gathered the scrapped data
  timeframes = ids.houses = prices.houses <- c()

# --------

  # Generate a random sleep timing in order to behave like
  # a human during the scraping and sleep the system
  rand.sleep <- runif( 1, 1, runif(1, 1, 10) )
  cat(sprintf('Sleeping time : %f secs', rand.sleep))
  Sys.sleep(rand.sleep)

# --------

  # Generate randomly -> {0, 1}
  gamble <- rbinom(n = 1, size = 1, prob = runif(n = 1, min = 0, max = 1))

  # According to the gamble choose which fetching function use
  if( gamble == 1 ) {
    user.agent <- bnbScrap:::sqlSendQuery('SELECT name FROM user_agent ORDER BY RANDOM() LIMIT 1') %>% pull(.)
    webpage.url <- GET(url = url_city, user_agent(user.agent)) %>% content()
  }

  if ( gamble == 0 ) {
    webpage.url <- read_html(url_city)
  }


  # Current time
  timestamps <- Sys.time()

# --------

  # Pagination's class
  nbr.pages.class <- "._1am0dt"

  # Get all the pagination number and select the max
  nbr.pages <-
    webpage.url %>% html_nodes(nbr.pages.class) %>% html_text() %>%
    as.integer() %<>% na.omit %>% max() - 1

# --------

  # Houses's class
  id.houses.class <- "._1rp5252"

  # Get the houses'ids
  current.id.houses <- webpage.url %>% html_nodes(id.houses.class) %>% html_attr("id")

# --------

  # Price's class
  price.houses.class <- "._hylizj6"

  # Get the prices
  current.price.houses <-
    webpage.url %>% html_nodes(price.houses.class) %>% html_text() %>%
    str_extract_all(., "[0-9]+") %>% unlist() %>% as.numeric() %>% na.omit()

# --------

  # Append the ids, the prices and the timeframes for the houses in the current page
  ids.houses <- c(ids.houses, current.id.houses)
  prices.houses <- c(prices.houses, current.price.houses)
  timeframes <- c(timeframes, rep(timestamps, length(current.id.houses)))

  # Advertizing
  cat("Initial page -- \n")
  cat(sprintf("Number of houses: %d \n", length(current.id.houses)))
  cat(sprintf("Number of prices %d \n \n", length(current.price.houses) ))

# ---------

  ############################################
  ############################################
  #             PAGINATION PHASE
  ############################################
  ############################################

  # The other generique page of the url
  base.other.url <- paste0(url_city, "&section_offset=")


  for (index.page in 1L:(nbr.pages)) {

# ---------

    # Construct the url for the current webpage
    current.url <- paste0(base.other.url, index.page)

    # Fetch the web page based on the url
    webpage.url <- read_html(current.url)

# ---------

    # Current time
    timestamps <- Sys.time()

    # get the informations related to the ids houses and append it into the base
    current.id.houses <- webpage.url %>% html_nodes(id.houses.class) %>% html_attr("id")

    current.price.houses <-
      webpage.url %>% html_nodes(price.houses.class) %>% html_text() %>%
      str_extract_all(., "[0-9]+") %>% unlist() %>% as.numeric() %>% na.omit()

# ---------

    # Append the ids, the prices and the timeframes for the houses in the current page
    ids.houses <- c(ids.houses, current.id.houses)
    prices.houses <- c(prices.houses, current.price.houses)
    timeframes <- c(timeframes, rep(timestamps, length(current.id.houses)))

    # Advertizing
    cat(sprintf("Current page: %d \n", index.page + 1))
    cat(sprintf("Number of houses: %d \n", length(current.id.houses)))
    cat(sprintf("Number of prices: %d \n", length(current.price.houses) ))
    cat(sprintf("Accumulated number of houses: %d \n\n", length(prices.houses)))

  }

  cat(sprintf("FINAL numbers: %d \n\n", length(prices.houses)))

  # build an object to return the whole informations and return it
  tmp <- list('bnb_flat_id' = ids.houses,
              'prices_houses' = prices.houses,
              'timestamps' = timeframes ) %>% as.data.frame()

  return(tmp)

}
