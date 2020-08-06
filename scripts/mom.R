#'  @author Max Lemes, \email{max@@ufg.br}
#'
#' Solving the problems with the tickers of companies;
#'
#'
#' @return the data cadastro.rds
#'
#' @depends  tidyverse, dplyr, GetDFPData
#'
#' @export


rm(list=ls())

# setting the working path
my.d<- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(my.d)

library(magrittr)
require(quantstrat)

load("../data/ibr4.rda")

#Load ETFs from yahoo
symbols <- ibr4$yahoo

data_ini <- Sys.Date() - months(13)
data_fim <- Sys.Date()

quantmod::getSymbols(
  symbols, 
  src = "yahoo", 
  from = data_ini,
  to = data_fim, 
  auto.assign = TRUE)

symbols_origin <- do.call(merge, lapply(symbols, get))


#Convert to monthly and drop all columns except Adjusted Close
for(symbol in symbols) {
  x <- get(symbol)
  #x <- to.monthly(x,indexAt='lastof',drop.time=TRUE)
  x <- xts::to.period(x, period = 'months')
  xts::indexFormat(x) <- '%Y-%m-%d'
  colnames(x) <- gsub("x",symbol,colnames(x))
  x <- x[,6] #drops all columns except Adjusted Close which is 6th column
  assign(symbol,x)
}

#merge the symbols into a single object with just the close prices
symbols_close <- do.call(merge, lapply(symbols, get))

names(symbols_close) <- gsub(pattern = ".SA.Adjusted", replacement = "", x = names(symbols_close))

#xts object of the 3 period ROC of each column in the close object
#The 3 period ROC will be used as the ranking factor
roc <- TTR::ROC(symbols_close, n = 6, type = "discrete")
roc <- roc[7:8,]

zerou <- function(x) {
  if (x>1){return(1)}
  else{return(0)}
}

qual <- TTR::ROC(symbols_close, n = 1, type = "discrete")
qual <- qual[2:13,]


q<- tibble::as_tibble(apply(sign(qual),1,FUN=function(x){x+1})/2)

  rowSums(apply(sign(qual),1,FUN=function(x){x+1}))/2)


#xts object with ranks
#symbol with a rank of 1 has the highest ROC
r <- xts::as.xts(t(apply(-roc, 1, rank)))


r <- r%>% zoo::fortify.zoo %>% tibble::as_tibble

df <- t(r)
colnames(df) <- df[1,]
df <- df[2:153,]


rr<- r[nrow(r),]
rr<-rr %>%
  gather(Ticker, Rank.MOM, -Index)%>%
  arrange(Rank.MOM)

readRDS("../data/cadastroB3.rds")
