genes <- read.csv("G:\\O meu disco\\PRODEI\\micai\\genes_list\\genesWhole.csv", header = FALSE)
genes$V1 <- toupper(as.character(genes$V1))

genes2 <- read.csv("G:\\O meu disco\\PRODEI\\micai\\map_geneName_ensembleId.csv")

genes3 <- read.csv("G:\\O meu disco\\PRODEI\\micai\\SAC\\map_all_id_genes.csv")

merge_genes <- merge(x=genes, y=genes2, by.x='V1', by.y='ensemble.GENENAME')

search_genes <- 