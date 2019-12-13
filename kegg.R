library(data.table)
library(clusterProfiler)
library(plyr)

listFiles = list.files(path="G:\\O meu disco\\PRODEI\\micai\\26mgenes\\ensemble\\parts", pattern="*.csv", full.names = TRUE)
temp <- listFiles[1:length(listFiles)]

idFile <- 1
for (file in temp){
  entrezFile <- fread(paste0(file), header = TRUE)
  kegg <- enrichKEGG(gene = entrezFile$entrezGeneId, organism = 'hsa')
  keggDf <- data.frame(kegg[])
  write.csv(keggDf, paste0("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\kegg\\file", idFile, ".csv"))
  idFile <- idFile + 1
  Sys.sleep(5)
}

#' Join all kegg files in a single file
filenames <- list.files(path = "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\kegg\\", pattern = "*.csv", full.names=TRUE)
import.list <- ldply(filenames, fread)
finalFile <- import.list[,-(11:19)]
removeNaRows <- which(is.na(finalFile[1:nrow(finalFile),]))
finalFile <- finalFile[-removeNaRows,-1]
write.csv(finalFile, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\kegg-result.csv")

#'If you already have the kegg results joined in the same file
kegg_result <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\kegg-result.csv")
dt <- data.table(kegg_result)
dt$geneID <- as.character(dt$geneID)
dt.out <- dt[, list(keggID = ID,
                    entrezID = unlist(strsplit(geneID, "/")),
                    Description = Description,
                    GeneRatio = GeneRatio,
                    BgRatio = BgRatio,
                    pvalue = pvalue,
                    p.adjust = p.adjust,
                    qvalue = qvalue,
                    Count = Count), by=1:nrow(dt)]
dt.out <- dt.out[,-1]
ensembl <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\esemble-complete.csv")
merge_result <- merge(x=ensembl, y=dt.out, by.x="ENTREZID", by.y="entrezID")
final_result <- merge_result[,-2]
write.csv(final_result, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\result_kegg.csv")
