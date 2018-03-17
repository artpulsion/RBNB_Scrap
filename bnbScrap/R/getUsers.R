


getUser <- function(houses.city) {

  # structure for all users
  all.users.flats.ids <- c()

  # convert factor as integer
  houses.city %<>% mutate( bnb_flat_id = as.integer(as.character(bnb_flat_id)) )

  # get the index of the iteration
  index <- 0

  # for each houses find the owner
  for (id in houses.city$bnb_flat_id) {

    # create the base url
    url.user <- sprintf("https://www.airbnb.pt/rooms/%d", id)

    # load the webpage
    webpage.url <- read_html(url.user)

    # get the all users present on the page
    user.class <- "._110nrr2"
    user.class <- "._ni9axhe"
    page <- webpage.url %>% html_nodes(user.class) %>% html_attr("href")


    # Why we will take the most frequent pattern of 'users/show/****' because
    # I didn't find a technic to get with good assurance the id of the host
    # based on the class. Thus, to target him in the chaos I decide to take the most
    # common string based on the pattern below and assume take this string is the host
    # because in generale the host is highly present in his page.

    # user id in string format : get the most frequent user
    user.id <- sort(table(page), decreasing=TRUE) %>% names(.) %>% first()

    # get the integer part of the string and convert it as numeric
    user.id %<>% str_match_all("[0-9]+") %>% unlist %>% as.numeric

    # fetch the user and his flat
    user.flat.id <- c(user.id, id)
    cat('\n')
    cat(url.user)
    cat('\n')


    # Information about the avancement
    index = index + 1
    cat( sprintf( 'Users: %d/%d \n', index, length(houses.city$bnb_flat_id)) )

    # bind the each user . flat at each iteration in order to construct a base
    all.users.flats.ids <- rbind(all.users.flats.ids, user.flat.id)
  }

  # convert the rows we binds as a dataframe
  all.users.flats.ids %<>% data.frame

  # rename the dataframe with the appropriate colnames which match with our api
  colnames(all.users.flats.ids) = c('bnb_user_id', 'bnb_flat_id')

  # get only the houses associated with a user
  walley <- inner_join(houses.city, all.users.flats.ids, by='bnb_flat_id')

  # return the joined dataframe
  return(walley)
}
