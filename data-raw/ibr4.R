## code to prepare `ibr4` dataset goes here

library(magrittr)

df.cad <- "data-raw/cadastroB3.rds" %>%
  readr::read_rds() %>%
  dplyr::mutate(
    tick = stringr::str_sub(on,1,4)
  )


df.ibra <- "data-raw/ibra.csv" %>%
  readr::read_csv2() %>%
  dplyr::rename(
    ticker= `Código `
  ) %>%
  dplyr::select(
    ticker
  ) %>%
  .[1:152, ] %>%
  dplyr::mutate(
    tick = stringr::str_sub(ticker,1,4)
  )


df <- dplyr::left_join(df.cad,df.ibra)

df_in <- df[!is.na(df$ticker),]
df_out <- df[is.na(df$ticker),]


df_out <- df_out%>%
  dplyr::slice(32,49,51,52,53,54,61,62,63,64,65,66,67,68,69,71,72,74,76,77,80,81,82,83,
               85,86,88,99,101,103,105,106,109,111,114,119)

df_out[7,14] <- "IDVL3"
df_out[17,14] <- "RNEW4"
df_out[23,14] <- "RANI3"
df_out[27,14] <- "FESA4"
df_out[28,14] <- "CGRA4"
df_out[29,14] <- "DOHL4"
df_out[30,14] <- "EALT4"
df_out[31,14] <- "TASA4"

df_out <- df_out%>%
  dplyr::mutate(ticker = tickers)

df <- dplyr::full_join(df_in, df_out)

ibr4 <- df %>%
  dplyr::select(
    id.company, name.company, ticker, main.sector, sub.sector, 
    segment, listing.segment
  )%>%
  dplyr::mutate(
    yahoo = paste0(ticker,".SA")
  )

usethis::use_data(ibr4, overwrite = TRUE)
