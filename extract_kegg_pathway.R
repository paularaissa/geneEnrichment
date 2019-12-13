library(KEGGREST)
library(tidyverse)
library(data.table)

PATH <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\keggRui"
PATH_OUTPUT <- "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\kegg_result\\"

idFile <- 1
lstFiles = list.files(path=PATH, pattern="*.csv", full.names = TRUE)
temp <- lstFiles[idFile:length(lstFiles)]

for (file in temp) {
  kegg_file <- fread(file = file, header = TRUE)
  query <- keggGet(kegg_file$keggId)
  df <- data.frame(entry=character(), name=character(), class=character(), pathway_map=character(),
                   network=character(), element=character(), disease=character(), drug=character(),
                   organism=character(), gene=character(), compound=character(), ko_pathway=character())
  for (idx in 1:length(query)) {
    df <- df %>% add_row(
      entry = paste(unlist(query[[idx]]$ENTRY), collapse='/'),
      name = paste(unlist(query[[idx]]$NAME), collapse='/'),
      class = paste(unlist(query[[idx]]$CLASS), collapse='/'),
      pathway_map = paste(unlist(query[[idx]]$PATHWAY_MAP), collapse='/'),
      network = paste(unlist(query[[idx]]$NETWORK$NETWORK), collapse='/'),
      element = paste(unlist(query[[idx]]$NETWORK$ELEMENT), collapse='/'),
      disease = paste(unlist(query[[idx]]$DISEASE), collapse='/'),
      drug = paste(unlist(query[[idx]]$DRUG), collapse='/'),
      organism = paste(unlist(query[[idx]]$ORGANISM), collapse='/'),
      gene = paste(unlist(query[[idx]]$GENE), collapse='/'),
      compound = paste(unlist(query[[idx]]$COMPOUND), collapse='/'),
      ko_pathway = paste(unlist(query[[idx]]$KO_PATHWAY), collapse='/'))
  }
  write.csv(df, paste0(PATH_OUTPUT, "kegg", idFile, ".csv"))
  idFile <- idFile + 1
  Sys.sleep(sample(60:65,1))
}
