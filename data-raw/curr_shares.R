## code to prepare `curr_shares` dataset goes here
library(magrittr)
###################################

# lendo os dados historicos
df.his <- "data-raw/history_shares.rds" %>%
  readr::read_rds()%>%
  dplyr::filter(ref.date == max(ref.date))

# lendo o ibr4
load("data/ibr4.rda")

# juntando os data frames
curr_shares <-dplyr::left_join(ibr4, df.his)


usethis::use_data(curr_shares, overwrite = TRUE)
