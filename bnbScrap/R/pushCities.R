


####
#
# This function gather the data from the google place id api and gather
# the informations we need in order to fill our database.
# The informations are posted into our local database.
#
####

pushCities = function() {

  # load the google key api to request the informations from the google api
  key <- 'AIzaSyBA-mEeBm_gta4wqxLewiGrO_UmHKWoP0E'
  cities.df <- readxl:::read_xlsx('data/most-popular-cities.xlsx')

  for (city in cities.df$City) {

    # Get the information from the current city
    df.city <- google_places(search_string = city, key = key)


    # Preload the url of our little api
    url <- 'http://localhost:5000/add_city'


    # Construct the body that we will append to our url in order to post
    city.body <- list('gp_id' = df.city$results$place_id,
                      'name' = df.city$results$name,
                      'lng' = df.city$results$geometry$location$lng,
                      'lat' = df.city$results$geometry$location$lat)


    # Post the information of the current city in our api
    POST(url = url, body = city.body, encode = 'json', verbose() )

  }

}
