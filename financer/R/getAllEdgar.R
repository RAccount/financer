
#' @import jsonlite httr stringr sqldf pbapply plyr

#' @export
getAllEdgar <- function(ticker)
{
  # get CIK # for ticker
  CIK = getCIK(ticker)
  # get data by passing in url & headers
  url <- paste0("https://data.sec.gov/api/xbrl/companyfacts/CIK",CIK,".json")
  print(url)
  pg <- GET(url = url,
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
    DEI = data.table::rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(data.table::rbindlist(data_raw$facts$dei[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
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
    INVEST = data.table::rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(data.table::rbindlist(data_raw$facts$invest[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
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
    SRT = data.table::rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(data.table::rbindlist(data_raw$facts$srt[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
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
    GAAP = data.table::rbindlist(lapply(as.list(1:N), function(ii){
      # extract data
      tmp = as.data.frame(data.table::rbindlist(data_raw$facts$`us-gaap`[[ii]]$units[[1]],use.names = TRUE, fill = TRUE))
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
  ALL <- plyr::rbind.fill(GAAP,DEI,SRT,INVEST)
  # return data frame
  ALL
}


# assign user agent
PASS <- new.env()
assign("usrAgent", "companyname.com email@companyName.com", env = PASS)
INFO <- read_json("https://www.sec.gov/files/company_tickers.json")
INFO <- data.table::rbindlist(INFO)
INFO$CIK = do.call(rbind, lapply(as.list(1:nrow(INFO)), function(ii){
  ZEROS = 10-as.numeric(str_count(INFO$cik_str[ii]))
  paste0(c(rep(0,ZEROS),INFO$cik_str[ii]), collapse = "")
}))
INFO <- as.data.frame(INFO)

getCIK = function(symbol){
  subset(INFO, INFO$ticker == paste(symbol))$CIK
}

