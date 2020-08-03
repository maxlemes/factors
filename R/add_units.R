#' add_units
#'
#' Esta função simplifica o valor de um número muito grande e
#' adiociona uma das unidades K, M, B, T.
#'
#' @param n o número a ser avaliado
#'
#' @return retorna o número com a unidade de grandeza e
#' duas casas decimais,
#'
#' @examples
#'add_units(232000000)
#'
#' x <- 230000000
#' add_units(x)
#'
#' \dontrun{
#'
#' add_units('2 milhões')
#' }
#'
#' @export
add_units <- function(n) {
  labels <- ifelse(abs(n) < 1000, n,  # less than thousands
                   ifelse(abs(n) < 1e6, paste0(round(n/1e3,2), 'K'),  # in thousands
                          ifelse(abs(n) < 1e9, paste0(round(n/1e6,2), 'M'),  # in millions
                                 ifelse(abs(n) < 1e12, paste0(round(n/1e9,2), 'B'), # in billions
                                        ifelse(abs(n) < 1e15, paste0(round(n/1e12,2), 'T'), # in trillions
                                               'too big!'
                                        )))))
  return(labels)
}
