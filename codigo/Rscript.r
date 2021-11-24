library(readr)
#dataframe
acc_med <- read_delim("##",
                      ";", escape_double = FALSE, col_types = cols(`AÑO` = col_character(),
                                                                   FECHA_ACCIDENTES = col_character()),
                      trim_ws = TRUE)
#limpieza
acc_med$AÑO[acc_med$AÑO == "2019\\r"] <- "2019"

acc_med$CLASE_ACCIDENTE[acc_med$CLASE_ACCIDENTE %in% c("Caída de Ocupante","Caida Ocupante", "Caída Ocupante")] <- "Caida de Ocupante"

colnames(acc_med)[colnames(acc_med) == "MES"] <- "DAÑOS" ##cambio nombre de columna
acc_med$DAÑOS[acc_med$DAÑOS == "Solo da\\xF1os"] <- "Solo daños"

##por facilidad trabajar con las localidades
##correcion de los nombres de algunas localidades
acc_med$LOCATION[acc_med$LOCATION %in% c("Bel\\xE9n", "Belén")] <- "Belen"
acc_med$LOCATION[acc_med$LOCATION %in% c("Corregimiento de San Crist\\xF3bal", "Corregimiento de San Cristóbal")] <- "Corregimiento de San Cristobal"
acc_med$LOCATION[acc_med$LOCATION %in% c("Corregimiento de San Sebasti\\xE1n de Palmitas", "Corregimiento de San Sebastián de Palmitas")] <- "Corregimiento de San Sebastian de Palmitas"
acc_med$LOCATION[acc_med$LOCATION %in% c("La Am\\xE9rica", "La América")] <- "La America"

##eliminando datos inecesarios
acc_med <- acc_med[!(acc_med$LOCATION %in% c("SN","Sin Inf","AU","In", "0")), ]

acc_med <- cbind(acc_med, 
                 strcapture('(\\d*[/]\\d*[/]\\d*)', 
                            acc_med$FECHA_ACCIDENTE, data.frame(FECHA = character())))

dbExport <- data.frame(FECHA = acc_med$FECHA, CLASE = acc_med$CLASE_ACCIDENTE, DAÑOS = acc_med$DAÑOS, LOCACION = acc_med$LOCATION)
write.csv(dbExport, 'db-acc-med.csv')
