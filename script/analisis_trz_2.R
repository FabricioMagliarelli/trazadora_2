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



}

trz2<- bind_rows(lista_trz2)

#ahora calculamos la edad al 30/04/2023

