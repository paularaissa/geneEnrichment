library(GO.db)

go_file <- read.csv("G:\\O meu disco\\PRODEI\\micai\\26mgenes\\result_go_ids.csv")

ids <- as.character(unique(go_file$go_id))

term <- as.data.frame(select(GO.db, ids, "TERM"))
ontology <- as.data.frame(select(GO.db, ids, "ONTOLOGY"))
definition <- as.data.frame(select(GO.db, ids, "DEFINITION"))

merge_df_aux <- merge(x=term, y=ontology, by="GOID")
merge_df <- merge(x=merge_df_aux, y=definition, by="GOID")
colnames(go_file) <- c('x', 'GENEID', 'GENENAME', 'ENTREZID', 'GOID', 'name_1006')
final_df <- merge(x=go_file, y=merge_df, by='GOID')
final_df <- final_df[,-c(2,6)]
write.csv(final_df, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\result_go_annotations.csv")
write.csv(merge_df, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\result_go_annotations_goids.csv")
