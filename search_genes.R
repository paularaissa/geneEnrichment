library(stringr)

ensemble_ids <- read.csv("G:\\O meu disco\\PRODEI\\micai\\map_geneName_ensembleId.csv")
geneList14 <- read.csv("G:\\O meu disco\\PRODEI\\micai\\SAC\\genes.csv", header = FALSE)

str = as.character(geneList14$V1)
geneList14$cleanName <- sub("?_.*", "", str)
ensemble_ids$ensemble.GENENAME <- as.character(ensemble_ids$ensemble.GENENAME)

##### Search in Esemble Ids Table
for (i in 1:nrow(geneList14)) {
  for(j in 1:nrow(ensemble_ids)){
    if(geneList14$cleanName[i] == ensemble_ids$ensemble.GENENAME[j]){
      #geneList14$ensemble_id[i] <- ensemble_ids$ensemble.GENEID[j]
      geneList14$ensemble_id[i] <- as.character(ensemble_ids$ensemble.GENEID[j])
      #cat(paste(geneList14$cleanName[i], ensemble_ids$ensemble.GENEID[j], "\n"))
      #listMatch[i] <- ensemble_ids$ensemble.GENEID
    }
  }
}

###### Map Entrez-Gene
entrez_table <- read.csv("G:\\O meu disco\\PRODEI\\micai\\entrezGene-complete.csv")
for (i in 1:nrow(geneList14)) {
  for(j in 1:nrow(entrez_table)){
    if(geneList14$ensemble_id[i] == entrez_table$ensembl_gene_id[j]){
      geneList14$entrez_id[i] <- as.character(entrez_table$entrezgene[j])
    }
  }
}

map_ids <- merge(geneList14, entrez_table, by.x="ensemble_id", by.y="ensembl_gene_id")
map_ids <- map_ids[,-c(4,5,6)]

write.csv(map_ids, "G:\\O meu disco\\PRODEI\\micai\\SAC\\map_all_id_genes.csv")

##### Map Uniprot Result
uniprot_table <- read.csv("G:\\O meu disco\\PRODEI\\micai\\uniprot-complete.csv")
uniprot_result <- merge(map_ids, uniprot_table_clean, by.x="ensemble_id", by.y="ENSEMBL")
uniprot_result$KEGG <- str_replace_all(uniprot_result$KEGG, "[[:punct:]]", "")
write.csv(uniprot_result, "G:\\O meu disco\\PRODEI\\micai\\SAC\\uniprot_result.csv")

##### Map Kegg Result
kegg_table <- read.csv("G:\\O meu disco\\PRODEI\\micai\\kegg-result.csv")
rmUniprotNa <- which(!is.na(uniprot_result$KEGG))
uniprotNoNas <- unique(uniprot_result[rmUniprotNa,])
#write.csv(uniprotNoNas, "G:\\O meu disco\\PRODEI\\micai\\SAC\\uniprot_result_noNas.csv")
#kegg_result <- merge(uniprotNoNas, kegg_table, by.x="KEGG", by.y="ID")  
#write.csv(kegg_result, "G:\\O meu disco\\PRODEI\\micai\\SAC\\uniprot_result_noNas.csv")


### Map GO Result
go_table <- read.csv("G:\\O meu disco\\PRODEI\\micai\\SAC\\goids.csv")
map_ids <- read.csv("G:\\O meu disco\\PRODEI\\micai\\SAC\\map_all_id_genes.csv")
go_result <- merge(map_ids, go_table, by.x="ensemble_id", by.y="ensembl_gene_id")
go_result <- go_result[,-c(2,6)]
write.csv(go_result, "G:\\O meu disco\\PRODEI\\micai\\SAC\\go_result.csv")
