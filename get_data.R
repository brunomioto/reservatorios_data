library(reservatoriosBR)
library(dplyr)
library(magrittr)
library(purrr)


reservatorios_dif <- reservatoriosBR::tabela_reservatorios() %>% 
  distinct(codigo) %>% 
  head()

testecsv <- read.csv("https://raw.githubusercontent.com/brunomioto/reservatorios_data/master/dados/reservatorios.csv")

busca_res <- function(codigo_reservatorio){
  
  reservatoriosBR::reservatorio_sin(codigo_reservatorio, data_inicial = "2021-02-01", data_final = "2021-02-31")
  
  
}

dados_reservatorios <- purrr::map_dfr(reservatorios_dif$codigo,
                                      busca_res)


new_data <- rbind(testecsv, dados_reservatorios)

new_data2 <- new_data %>% 
  distinct() %>% 
  arrange(codigo_reservatorio, data)

# salvar a versao csv
write.csv(new_data2, "dados/reservatorios.csv")
