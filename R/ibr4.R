#' Dados das empresas viáveis da B3
#'
#' Os dados foram gerados considerando todas empresas do índice IBrA
#' e além disso foram acrecentadas empresas conhecidas com boa
#' liquidez. 
#' Ao todo temos 173 empresas e 182 Tickers
#'
#' @format Uma tabela com 8 colunas e 182 linhas:
#' 
#' Colunas:   id.company, 
#'            name.company, 
#'            ticker, 
#'            main.sector, 
#'            sub.sector, 
#'            segment, 
#'            listing.segment
#'            yahoo
#'
#' \describe{
#'    \item{yahoo}{Código da Empresa no Yahoo Finance}
#' }
#' @source  B3 e CVM
"ibr4"