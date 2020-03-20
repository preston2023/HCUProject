install.packages("readr")
library(readr)
install.packages("readxl")
library(readxl)
install.packages("dplyr")
library(dplyr)
library(stringr)
install.packages("comorbidity")
library(comorbidity)

CORE <- read_csv("NEDS_2016_CORE1.csv", col_names = F, skip = 1)
IP_sample <- read_csv("NEDS_2016_IP.sample1.csv",   col_names = F, skip = 1)
ED_sample <- read_csv("NEDS_2016_ED.sample.csv",   col_names = F, skip = 1)
CORERAN <- read_csv("NEDS_2016_CORE.sample.random.csv", col_names = F, skip = 1)
Headers <- read_excel("Headers1.xlsx")

add_header <- function(df, header) {
  header <- header[!is.na(header)]
  colnames(df) = header
  return(df) 
  }

CORE <- add_header(CORE, (Headers[["CORE"]]))
IP_sample <- add_header(IP_sample, (Headers[["IP_sample"]]))
ED_sample <- add_header(ED_sample, (Headers[["ED_sample"]]))
CORERAN <- add_header(CORERAN, (Headers[["CORE"]]))


#IP_sample2 <- dplyr::slice(IP_sample, 1:20000)
#ED_sample2 <- dplyr::slice(ED_sample, 1:20000)

#"I25709"
#test2 <- CORE %>%
  #dplyr::filter_at(vars(starts_with("I10_DX")), any_vars((.)== "N17100"))

#CORE2 <- dplyr::slice(CORE, 1:20)
#CORE2x <- select(CORE2, "KEY_ED", c("I10_DX1":"I10_DX30"))
#CORE2id <- select(CORE2, "KEY_ED")
#CORE2code <- select(CORE2, c("I10_DX1":"I10_DX30"))
#como <- comorbidity(x = "CORE2x", id = "CORE2id", code = "CORE2code", score = "charlson", assign0 = TRUE, icd = "icd10")


CABGProc <- IP_sample %>%
  dplyr::filter(I10_PR_IP1 == "02120Z9" | I10_PR_IP1 == "021009W" |  I10_PR_IP1 == "06BQ0ZZ" | I10_PR_IP1 == "5A1221Z")

test <- glm(DIED_VISIT ~ I10_NDX + AGE + FEMALE, data = CORE)
summary(test)

CABGProc <- left_join(CABGProc, CORE, by = c("KEY_ED", "KEY_ED"))

DIED <- CABGProc %>%
  dplyr::filter(DIED_VISIT==1 || DIED_VISIT==2)

DIED1 <- CORE %>%
  dplyr::filter(DIED_VISIT==1 || DIED_VISIT==2)

DIED2 <- CORERAN %>%
  dplyr::filter(DIED_VISIT==1 || DIED_VISIT==2)

str(CABGProc$KEY_ED)
str(CORE$KEY_ED)
