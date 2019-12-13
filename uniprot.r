library(UniProt.ws)
library(data.table)
library(plyr) 

PATH <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\ensemble\\parts\\list_win"
UNIPROT_COLUMNS <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\colunasUniprot.csv"
PATH_OUTPUT <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot"
PATH_DIV <- "\\"

idFile <- 1
lstFiles = list.files(path=PATH, pattern="*.csv", full.names = TRUE)
temp <- lstFiles[idFile:length(lstFiles)]
up <- UniProt.ws()

columnsUpFile <- read.csv(UNIPROT_COLUMNS)
columnsUp <- as.character(columnsUpFile$columnsUp)
#kt <- "ENTREZ_GENE"
kt <- "ENSEMBL"
for (file in temp){
  ensemble <- fread(file = file, header = TRUE)
  keys <- unique(ensemble$ensembleGeneId)
  resultUniprot <- select(up, keys, columnsUp, kt)
  write.csv(resultUniprot, paste0(PATH_OUTPUT, "uniprot", idFile, ".csv"))
  idFile <- idFile + 1
  Sys.sleep(sample(60:65,1))
}

##'
##'JOIN CSV FILES OF RESULTS
##'
INPUT_PATH <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot3\\"
OUTPUT_FILE <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result_3.csv"

filenames <- list.files(path = INPUT_PATH, pattern = "*.csv", full.names=TRUE)
#import.list <- ldply(filenames, function(x){read.csv(file=x, header=TRUE)})
import.list <- ldply(filenames, function(x){fread(file=x, header = TRUE)})

# finalFile <- import.list[,-1]
removeNaRows <- which(is.na(import.list$`GO-ID`))
finalFile <- import.list[-removeNaRows,]
write.csv(finalFile, OUTPUT_FILE, row.names = FALSE)

result_files <- c("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result_1.csv",
                  "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result_2.csv",
                  "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result_3.csv")

import.list <- ldply(result_files, function(x){fread(file=x, header = TRUE)})
import.list <- import.list[,-1]
import.list <- import.list[,-10]
write.csv(ids_unics, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result.csv")
ids_unics <- unique(import.list)
import.list <- import.list[unique(import.list), ]

ensembl <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\esemble-complete.csv")
merge_result <- merge(x=ensembl, y=final_file, by.x="GENEID", by.y="ENSEMBL")

file <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result.csv")

reactome <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\result-reactome.csv")
