####################################################
# JOIN ALL CSV FILES
library(plyr)  
library(data.table)

INPUT_PATH <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot3\\"
OUTPUT_FILE <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\uniprot_result_3.csv"

filenames <- list.files(path = INPUT_PATH, pattern = "*.csv", full.names=TRUE)
#import.list <- ldply(filenames, function(x){read.csv(file=x, header=TRUE)})
import.list <- ldply(filenames, function(x){fread(file=x, header = TRUE)})

# finalFile <- import.list[,-1]
 removeNaRows <- which(is.na(import.list$`GO-ID`))
 finalFile <- import.list[-removeNaRows,]
write.csv(finalFile, OUTPUT_FILE, row.names = FALSE)
