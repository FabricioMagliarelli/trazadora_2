library(usethis)
library(devtools)
library(googledrive)
library(googlesheets4)
library(tidyverse)
library(lubridate)
library(readxl)
#install.packages("openxlsx",dependencies = T)
library(openxlsx)
#install.packages("stringdist",dependencies = T)
library(stringdist)

#cargamos los archivos de trazadoras
filelist<- list.files("input")

lista_trz2<- list()

for (i in seq_along(filelist)) {
  
lista_trz2[[i]]<-  read_delim(paste0("input/",
                                     filelist[i]),
                              skip = 1,
                              col_names = F,
                              col_types = "ccccccDcDnnnccccccc")

lista_trz2[[i]]$prov <- sub(" .*", "",filelist[i])

}

trz2<- bind_rows(lista_trz2)

#ahora calculamos la edad al 30/04/2023
trz2 <- trz2 %>% 
  mutate(edad = floor(time_length(ymd("2023-04-30") - ymd(X7), unit = "year")))

#y nos quedamos con los elegibles para el indicador. 
#Son todos aquellos nenes menores a 3 años o que cumplieron los 3 años
#justo entre el 1er dia del 3 mes del intervalo hasta el ultimo dia del mes de cierre
#(en este caso seria entre el 01/03/2023 - 30/04/2023. Es decir que nacieron despues del 01/03/2020)
trz2_0_a_3<- filter(trz2,edad <= 3 & X7 >= "2020-03-01")

#ahora nos quedanos solo con los DNI unicos
trz2_0_a_3_unicos<- trz2_0_a_3 %>%
  distinct(X4,.keep_all = T)

#armamos la tabla para presentar
trz2_por_provincia<- count(trz2_0_a_3_unicos,prov)

#guardamos
write.csv(trz2_0_a_3_unicos,"output/trz2_de_0_a_3_años.csv")
write.xlsx(trz2_por_provincia,"output/trz2_de_0_a_3_años_por_provincia.xlsx")

