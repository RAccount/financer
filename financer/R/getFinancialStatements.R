
#' @import jsonlite httr stringr sqldf pbapply plyr

#' @export





financial_statement <- function (stock, key, form, fp, fy) {
  taxonomy <- read_xlsx("./taxonomy/GAAP_Taxonomy_2022.xlsx")
  presentation <- read_xlsx("./taxonomy/GAAP_Taxonomy_2022.xlsx", "Presentation")
  df <- getAllEDGAR(ticker=stock)
  entries <- sqldf(sprintf("select * from df where fy='%s' and form='%s'", fy,form))
  
  
  
  ledger_entries <- sqldf("select t.balance, d.*, t.type, t.periodType  from taxonomy t inner join df d on t.name = d.desc  order by desc ")
  
  financial_statement_keys <- sqldf(sprintf("select * from presentation where definition = '%s'",key))
  fs_ledger_entries <- sqldf("select le.*, fsk.label, fsk.parent from ledger_entries le inner join financial_statement_keys fsk on fsk.name = le.desc order by fsk.name")
  
  is_2022 <- sqldf(sprintf("select max(balance) action, max(label) label,  max(val) value, max(fy) `fiscal year`,  max(start) start, max(parent), max(end) end , desc  from fs_ledger_entries where fp='%s' and form='%s' and fy='%s' group by desc", fp, form, fy))
  #is_2022 <- sqldf(sprintf("select *  from fs_ledger_entries where fp='%s' and form='%s' and fy='%s' ", fp, form, fy))
  
}


