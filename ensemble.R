library(EnsDb.Hsapiens.v75)
library(data.table)
library(plyr)
library(readr)

GENEFILE <- "G:\\O meu disco\\PRODEI\\micai\\genes_list\\genesWhole.csv"
PATH_OUTPUT <- "G:\\O meu disco\\PRODEI\\micai\\genes_list\\ensemble"
SEP_DIRECTORY <- "\\"

genes <- fread(GENEFILE, header = FALSE)
genes 
genes$V1 <- toupper(as.character(genes$V1))
gns <- toupper(genes$V1)
ini <- 1
fim <- 100
edb <- EnsDb.Hsapiens.v75
idFile <- 1
while(ini < length(gns)) {
  result <- select(edb, keys=gns[ini:fim], keytype="GENENAME", 
                   columns=c("GENEID", "ENTREZID"))
  if(is.data.frame(result)) {
    ini <- fim + 1
    fim <- fim + 100
    if (fim > length(gns)) 
      fim <- length(gns)
    write.csv(result, paste0(PATH_OUTPUT, SEP_DIRECTORY, "EnsDbHsapiens", idFile, ".csv"))
    idFile <- idFile + 1
  }
}

myfiles <- list.files(path = PATH_OUTPUT, pattern = "*.csv", full.names = TRUE)
dat_csv <- ldply(myfiles, read_csv)
write.csv(dat_csv, paste0(PATH_OUTPUT, SEP_DIRECTORY, "esemble-complete", ".csv"))

missing_genes <- merge(x=genes, y=dat_csv, by.x='V1', by.y='GENENAME')
