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

library(dplyr)
library(XML)
library(tidyr)
library(quant)
library(readr)
library(rvest)
library(stringr)


ibra <- read_csv2("../raw-data/ibra.csv") %>%
  rename(Papel = `Código `, NOME = "Ação", TIPO = "Tipo")%>%
  select(Papel, NOME, TIPO)

ibra <- ibra[1:152,]


urlfund <- "https://www.fundamentus.com.br/resultado.php"
fundamentus <-  read_html(urlfund) %>% html_table()
fundamentus <-  fundamentus[[1]]

fundamentus <- left_join(ibra,fundamentus)%>%
  distinct()

df <- fundamentus %>%
  mutate_if(is.character,
            str_replace_all, pattern = "\\.", replacement = "")%>%
  mutate_if(is.character,
            str_replace_all, pattern = ",", replacement = ".")%>%
  mutate_if(is.character,
            str_replace_all, pattern = "\\%", replacement = "")

df[,4:23] = apply(df[,4:23], 2, function(x) as.numeric(as.character(x)));

df <- df %>%
  mutate(EV  = Cotação*`EV/EBIT`/`P/EBIT`
  )








urlstatus <- "https://statusinvest.com.br/category/advancedsearchresultexport?search=%7B%22Sector%22%3A%22%22%2C%22SubSector%22%3A%22%22%2C%22Segment%22%3A%22%22%2C%22my_range%22%3A%220%3B25%22%2C%22dy%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_L%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_VP%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_Ativo%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22margemBruta%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22margemEbit%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22margemLiquida%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_Ebit%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22eV_Ebit%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22dividaLiquidaEbit%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22dividaliquidaPatrimonioLiquido%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_SR%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_CapitalGiro%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22p_AtivoCirculante%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22roe%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22roic%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22roa%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22liquidezCorrente%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22pl_Ativo%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22passivo_Ativo%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22giroAtivos%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22receitas_Cagr5%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22lucros_Cagr5%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%2C%22liquidezMediaDiaria%22%3A%7B%22Item1%22%3Anull%2C%22Item2%22%3Anull%7D%7D&CategoryType=1"
status <- read_csv2(urlstatus)

ibras <- ibra%>%rename(TICKER = "Papel")

status <- left_join(ibras,status)

fundamentus <- fundamentus %>%
  mutate(fundamentus$EV <- fundamentus$Cotação*fundamentus$`EV/EBIT`/fundamentus$`P/EBIT`)

fundamentus <- as.numeric(fundamentus[,4:])
