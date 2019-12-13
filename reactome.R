library(ReactomePA)
library(stringr)
require(data.table)

ensembl <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\esemble-complete.csv")

x = enrichPathway(gene = ensembl$ENTREZID, readable = T)

reactome.result = as.data.frame(x)

dt <- data.table(reactome.result)
dt.out <- dt[, list(geneID = unlist(strsplit(geneID, "/")),
                    reactomeID = ID, 
                    Description = Description,
                    GeneRatio = GeneRatio,
                    BgRatio = BgRatio,
                    pvalue = pvalue,
                    p.adjust = p.adjust,
                    qvalue = qvalue,
                    Count = Count), by=1:nrow(dt)]
dt.out <- dt.out[,-1]

write.csv(dt.out, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\result-reactome.csv", row.names = FALSE)
