# build the package
# construct the environnement to have a package that works perfectly
# push everything on github
# create a database for the house, the cities with flask for example


library(rvest)
library(stringr)
library(magrittr)
library(tidyverse)


#con <- file('data/simplemaps-worldcities-basic.csv')
#cities <- read.csv(con) %>% filter(., city == 'Porto' )

#cities.scrap <- world_cities %>% pull(city)
#cities.informations <- data.frame()


for(city in cities.scrap) {

  url <- sprintf("https://www.airbnb.fr/api/v2/autocompletes?country=PT&key=d306zoyjsyarp7ifhu67rjxn52tv0t20&language=fr&locale=fr&num_results=5&user_input=%s&api_version=1.0.3", city)

  webpage.url <- try(read_html(url))

  if (inherits(webpage.url, "try-error")) {
    next
  }


  webpage.url <- webpage.url %>% html_text() %>% fromJSON()

  city.informations <- try( c(webpage.url$autocomplete_terms[[1]]$explore_search_params$place_id,
                              webpage.url$autocomplete_terms[[1]]$location$location_name ) %>% data.frame() %>% t() )


  if (inherits(city.informations, "try-error")) {
    next
  }


  cities.informations <- try(rbind(cities.informations, city.informations))
  if (inherits(cities.informations, "try-error")) {
    next
  }

}

colnames(cities.informations) <- c('place.id', 'googple.place.id', 'location.name')







##########
# ----
# Get the price and the name of the houses available
# ----
##########

# Fetch the web page based on the url
webpage.url <- read_html(url)

# Fetch the price for this request
price.class <- "._hylizj6"
price.pattern <- c('Prix')
price.nodes <- webpage.url %>% html_nodes(price.class) %>% html_text()
price.nodes <- price.nodes[grepl(price.pattern, price.nodes)] %>% gsub(price.pattern, "", .)

# Fetch the location for this request
place.class <- "._1qp0hqb"
place.nodes <- webpage.url %>% html_nodes(place.class) %>% html_text()
place.nodes <- place.nodes[grepl(place.pattern, place.nodes)] %>% gsub(place.pattern, "", .)


df.report <- cbind(place.nodes, price.nodes)
df.report <- cbind(place.nodes, price.nodes)
