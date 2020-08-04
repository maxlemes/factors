#' 1) Lê o arquivo com o histórico das ações
#'
#' 2) Fitra as ações correntes em relação ao último balanço
#' 
#' 3) Filtra as empresas com o índice ibr4
#'
#' @format Uma tabela com 12 colunas e 187 linhas:
#' 
#' Colunas:   id.company, 
#'            name.company, 
#'            ticker, 
#'            main.sector, 
#'            sub.sector, 
#'            segment, 
#'            listing.segment
#'            yahoo
#'            ref.date
#'            qtd.ord.shares
#'            qtd.pref.shares
#'            total.shares
#'
#' \describe{
#'    \item{yahoo}{Código da Empresa no Yahoo Finance}
#' }
#' @source  B3 e CVM
"curr_shares"