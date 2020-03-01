install.packages("readr")
library(readr)
install.packages("readxl")
library(readxl)
install.packages("dplyr")
library(dplyr)

memory.limit()

CORE <- read_csv("NEDS_2016_CORE.csv", col_names = F, skip = 1)
IP_sample <- read_csv("NEDS_2016_IP.sample.csv",   col_names = F, skip = 1)
ED_sample <- read_csv("NEDS_2016_ED.sample.csv",   col_names = F, skip = 1)
Headers <- read_excel("Headers1.xlsx")

add_header <- function(df, header) {
  header <- header[!is.na(header)]
  colnames(df) = header
  return(df) 
  }

CORE <- add_header(CORE, (Headers[["CORE"]]))
IP_sample <- add_header(IP_sample, (Headers[["IP_sample"]]))
ED_sample <- add_header(ED_sample, (Headers[["ED_sample"]]))

CORE2 <- dplyr::slice(CORE, 1:20000)
IP_sample2 <- dplyr::slice(IP_sample, 1:20000)
ED_sample2 <- dplyr::slice(ED_sample, 1:20000)

maindata <- dplyr::left_join(CORE2, ED_sample2, by = c("KEY_ED" = "KEY_ED"))
maindata <- left_join(maindata, IP_sample2, by = c("KEY_ED" = "KEY_ED"))

CABGProc <- filter(IP_sample, I10_PR_IP1 == "02120Z9" | I10_PR_IP1 == "021009W" |  I10_PR_IP1 == "06BQ0ZZ" | I10_PR_IP1 == "5A1221Z")

