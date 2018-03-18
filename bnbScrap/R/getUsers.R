


getUser <- function(houses.city) {

  # structure for all users
  all.users.flats.ids <- c()

  # convert factor as integer
  houses.city %<>% mutate( bnb_flat_id = as.integer(as.character(bnb_flat_id)) )

  # get the index of the iteration
  index <- 0

  # for each houses find the owner
  for (id in houses.city$bnb_flat_id) {

    # acces to the house with his with his id
    url.flat <- sprintf("https://www.airbnb.pt/rooms/%d", id)

    # load the webpage
    webpage.url <- read_html(url.flat)

    # get the potential user in the current page
    class.potential.users <- "._2930ex"
    page.potential.users <- webpage.url %>% html_nodes(class.potential.users)

    # get the ids of the potential users of the current houses
    all.pot.users.ids <- c()
    for (node in page.potential.users) {

      pot.users.ids <- node %>% as.character %>%
        str_match_all("[0-9]+") %>% unlist %>% as.numeric

      all.pot.users.ids <- c(all.pot.users.ids, pot.users.ids)
    }


    all.pot.users.ids <- all.pot.users.ids[!all.pot.users.ids < 10000]
    all.pot.users.ids <- table(all.pot.users.ids) %>% names(.) %<>% as.numeric


    # get the users ids and filter to find the good
    user.class_.user <- "._110nrr2"
    page <- webpage.url %>% html_nodes(user.class_.user) %>% html_attr('href')


    user.id <-
      sort(table(page), decreasing=TRUE) %>% names(.) %>%
      str_match_all("[0-9]+") %>% unlist() %>% as.numeric


    # get the user id from the current flat
    user.id <- all.pot.users.ids[all.pot.users.ids %in% user.id]


    # fetch the user and his flat
    user.flat.id <- c(user.id, id)
    cat('\n')
    cat(url.flat)
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
  walley <- walley %>% group_by(bnb_user_id) %>% ddply(.variables = c('bnb_flat_id'), head, 1)

  # return the joined dataframe
  return(walley)
}
