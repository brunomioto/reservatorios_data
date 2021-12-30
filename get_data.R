library(reservatoriosBR)
library(dplyr)
library(magrittr)
library(purrr)
library(readr)

testecsv <- read_csv("https://raw.githubusercontent.com/brunomioto/reservatorios_data/master/dados/reservatorios.csv",
                     col_types =  cols(
                       data = col_date()
                     ))

glimpse(testecsv)

reservatorios_dif <- reservatoriosBR::tabela_reservatorios() %>% 
  filter(sistema == "sin") %>% 
  distinct(codigo)

busca_res <- function(codigo_reservatorio){
  
  reservatoriosBR::reservatorio_sin(codigo_reservatorio, data_inicial = "2000-01-01", data_final = "2000-01-02")
  
}

dados_reservatorios <- purrr::map_dfr(reservatorios_dif$codigo,
                                      busca_res)


new_data <- rbind(testecsv, dados_reservatorios)

new_data2 <- new_data %>% 
  distinct() %>% 
  arrange(codigo_reservatorio, data)

new_data2$data <- as.Date(new_data2$data)

# salvar a versao csv
write_csv(new_data2, "dados/reservatorios.csv")
