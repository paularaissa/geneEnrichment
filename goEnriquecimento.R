library(data.table)
library(GOfuncR)
library(biomaRt)
#library(beepr)

ENSEMBLE_FILE <- "/home/paula/Doutoramento/26mgenes/esemble-complete.csv"
OUTPUT_FILE <- "/home/paula/Doutoramento/26mgenes/result_go_ids.csv"

############## If you already have Go-ids ################
# go_ids <- read.csv("/home/paula/Doutoramento/26mgenes/result_go_ids.csv")
# ensemble.aux <- ensemble[,-c(1,2)]
# merge_file <- merge(x=ensemble.aux, y=go_ids, by.x='GENEID', by.y='ensembl_gene_id')
# merge_file <- merge_file[,-c("X.1", "X")]
# # clean_empty_rows <- which(go_ids$go_id=='')
# # go_ids <- go_ids[-clean_empty_rows,]
# write.csv(merge_file, OUTPUT_FILE)

##########################################################

ensemble <- fread(ENSEMBLE_FILE)
gene_id <- unique(ensemble$GENEID)

ensembl <- useMart("ensembl")
ensembl <- useDataset("hsapiens_gene_ensembl",mart=ensembl)
filters <- listFilters(ensembl)
attributes = listAttributes(ensembl)
goids <- getBM(
  attributes=c('ensembl_gene_id','go_id', 'name_1006'), 
  filters='ensembl_gene_id', 
  values=gene_id, 
  mart=ensembl)
clean_nas <- goids[-which(goids$go_id == ""),]
goidsList <- unique(goids$go_id)

write.csv(goids, OUTPUT_FILE)

anno_genes <- get_anno_genes(go_ids = goidsList)
#direct_anno <- read.csv("G:\\O meu disco\\PRODEI\\microglia-genes\\go_annotations.csv")
direct_anno <- get_anno_categories(anno_genes$gene)
## In case of restory 
write.csv(direct_anno, "G:\\O meu disco\\PRODEI\\micai\\26mgenes\\go_annotations.csv")
gene_ids <- unique(direct_anno$gene)
input_hyper = data.frame(gene_ids, is_candidate=1)
# res_hyper = go_enrich(input_hyper, n_randset=100)
# write.csv(res_hyper[[1]], "G:\\O meu disco\\PRODEI\\microglia-genes\\goEnrich100.csv")
# remove(res_hyper)
res_hyper2 = go_enrich(input_hyper, n_randset=50)
write.csv(res_hyper2[[1]], "G:\\O meu disco\\PRODEI\\microglia-genes\\goEnrich50.csv")
remove(res_hyper2)
res_hyper3 = go_enrich(input_hyper, n_randset=150)
write.csv(res_hyper3[[1]], "G:\\O meu disco\\PRODEI\\microglia-genes\\goEnrich150.csv")
remove(res_hyper3)
res_hyper4 = go_enrich(input_hyper, n_randset=200)
write.csv(res_hyper4[[1]], "G:\\O meu disco\\PRODEI\\microglia-genes\\goEnrich200.csv")
remove(res_hyper4)

beep(sound = 8)

#'Tentar com topGO https://bioconductor.org/packages/release/bioc/vignettes/topGO/inst/doc/topGO.pdf
#'

#write.csv(input_hyper, OUTPUT_FILE)
