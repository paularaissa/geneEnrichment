##### 
#SPLIT DATA

INPUT_FILE <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\kegg_netids.txt"
OUTPUT_PATH <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\keggRui\\"

idFile <- 1
import.list <- read.csv(INPUT_FILE, header = FALSE)
import.list <- data.frame(import.list$V1)
colnames(import.list) <- c("keggId")
#Split dataset into small sets with 10 elements
iris.split <- split(import.list, (as.numeric(rownames(import.list)) - 1) %/% 10) 
for (df in iris.split) {
  write.csv(df, paste0(OUTPUT_PATH, "file", idFile, ".csv"))
  idFile <- idFile + 1
}
