install.packages("jsonlite")
install.packages("data.table")
install.packages("httr")
install.packages("pbapply")
install.packages("stringr")
install.packages("plyr")
install.packages("sqldf")
install.packages("devtools")

# assign user agent
PASS <- httr::new.env()
assign("usrAgent", "companyname.com email@companyName.com", env = PASS)
INFO <- read_json("https://www.sec.gov/files/company_tickers.json")
INFO <- rbindlist(INFO)
INFO$CIK = do.call(rbind, lapply(as.list(1:nrow(INFO)), function(ii){
  ZEROS = 10-as.numeric(str_count(INFO$cik_str[ii]))
  paste0(c(rep(0,ZEROS),INFO$cik_str[ii]), collapse = "")
}))
INFO <- as.data.frame(INFO)

getCIK = function(symbol){
  subset(INFO, INFO$ticker == paste(symbol))$CIK
}


getAllEDGAR = function(ticker)
{
  # get CIK # for ticker
  CIK = getCIK(ticker)
  # get data by passing in url & headers
  pg <- GET(url = paste0("https://data.sec.gov/api/xbrl/companyfacts/CIK",CIK,".json"),
            config = httr::add_headers(`User-Agent` = PASS$usrAgent,
                                       `Accept-Encoding` = 'gzip, deflate'))
  
  # raw data
  data_raw <- try(content(pg, as="text", encoding="UTF-8") %>% fromJSON(pg, flatten=FALSE),silent = TRUE)
  # ********************************************************************************************************
  #                                                   DEI
  # ********************************************************************************************************
  N = length(data_raw$facts$dei)
  if(N >= 1)
  {
    DEI = rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(rbindlist(data_raw$facts$dei[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
      # add description column
      tmp$desc <- names(data_raw$facts$dei)[ii]
      # delete duplicates
      tmp <- tmp[!duplicated(tmp$end),]
      # add ticker column
      tmp$symbol <- ticker
      # return df
      tmp
    }),use.names=TRUE, fill=TRUE)
  }else{
    DEI = NULL
  }
  # ********************************************************************************************************
  #                                                   INVEST
  # ********************************************************************************************************
  N = length(data_raw$facts$invest)
  if(N >= 1)
  {
    INVEST = rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(rbindlist(data_raw$facts$invest[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
      # add description column
      tmp$desc <- names(data_raw$facts$invest)[ii]
      # delete duplicates
      tmp <- tmp[!duplicated(tmp$end),]
      # add ticker column
      tmp$symbol <- ticker
      # return df
      tmp
    }),use.names=TRUE, fill=TRUE)
  }else{
    INVEST = NULL
  }
  # ********************************************************************************************************
  #                                                   SRT
  # ********************************************************************************************************
  N = length(data_raw$facts$srt)
  if(N >= 1)
  {
    SRT = rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(rbindlist(data_raw$facts$srt[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
      # add description column
      tmp$desc <- names(data_raw$facts$srt)[ii]
      # delete duplicates
      tmp <- tmp[!duplicated(tmp$end),]
      # add ticker column
      tmp$symbol <- ticker
      # return df
      tmp
    }),use.names=TRUE, fill=TRUE)
    
  }else{
    SRT = NULL
  }
  # ********************************************************************************************************
  #                                                   US-GAAP
  # ********************************************************************************************************
  N = length(data_raw$facts$`us-gaap`)
  if(N >= 1)
  {
    GAAP = rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(rbindlist(data_raw$facts$`us-gaap`[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
      # add description column
      tmp$desc <- names(data_raw$facts$`us-gaap`)[ii]
      # delete duplicates
      tmp <- tmp[!duplicated(tmp$end),]
      # add ticker column
      tmp$symbol <- ticker
      # return df
      tmp
    }),use.names=TRUE, fill=TRUE)
    # re-order
    GAAP = GAAP[,c("start","end","val","accn","fy","fp","form","filed","frame","desc","symbol" )]
  }else{
    GAAP = NULL
  }
  # combine ALL data
  ALL <- rbind.fill(GAAP,DEI,SRT,INVEST)
  # return data frame
  ALL
}

library(readxl)





financial_statement <- function (stock, key, form, fp, fy) {
  ls()
  taxonomy <- read_xlsx("./taxonomy/GAAP_Taxonomy_2022.xlsx")
  # presentation <- read_xlsx("../../taxonomy/GAAP_Taxonomy_2022.xlsx", "Presentation")
  df <- getAllEDGAR(ticker=stock)
  entries <- sqldf(sprintf("select * from df where fy='%s' and form='%s'", fy,form))
  
  
  
  ledger_entries <- sqldf("select t.balance, d.*, t.type, t.periodType  from taxonomy t inner join df d on t.name = d.desc  order by desc ")
  
  financial_statement_keys <- sqldf(sprintf("select * from presentation where definition = '%s'",key))
  fs_ledger_entries <- sqldf("select le.*, fsk.label, fsk.parent from ledger_entries le inner join financial_statement_keys fsk on fsk.name = le.desc order by fsk.name")
  
  is_2022 <- sqldf(sprintf("select max(balance) action, max(label) label,  max(val) value, max(fy) `fiscal year`,  max(start) start, max(parent), max(end) end , desc  from fs_ledger_entries where fp='%s' and form='%s' and fy='%s' group by desc", fp, form, fy))
  #is_2022 <- sqldf(sprintf("select *  from fs_ledger_entries where fp='%s' and form='%s' and fy='%s' ", fp, form, fy))
  
}


#' @export
get_income_statement <- function(stock, form, fp, fy ){ 
  
  financial_statement(stock, income_statement,form, fp, fy)
  
}

