# Le as informacoes da base FRE e FCA
# Filtra e organiza a quantidade de acoes ON, PN e UNIT

rm(list=ls())

# setting the working path
my.d<- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(my.d)

library(magrittr)
###################################

# lendo os dados historicos
df.his <- "../data-raw/history_shares.rds" %>%
  readr::read_rds()%>%
  dplyr::filter(ref.date == max(ref.date))

# lendo o ibr4
load("../data/ibr4.rda")

# juntando os data frames
curr_shares <-left_join(ibr4, df.his)

