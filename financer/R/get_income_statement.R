

income_statement <- "124100 - Statement - Statement of Income"
balance_sheet <- "104000 - Statement - Statement of Financial Position, Classified"
cash_flow_statement <- "152200 - Statement - Statement of Cash Flows"

stockholder_equity_statement <- "148600 - Statement - Statement of Shareholders' Equity"

#' This function imports the income statement of the equity from the 10-Q.
#' @param stock stock ticker to lookup such as ML for NYSE:MONEYLION
#' @param fy fiscal year for the period to look up such as 2021
#' @param fp fiscal period within the fiscal year such as Q1 or Q3 or at times FY if its for the whole year
#' @param form the form to scrape  from edgar such as 10-Q or 10-K 
#' @return a dataframe with the income statement
#' @export
get_income_statement <- function(stock, fy, form="10-K", fp="FY" ){

  financial_statement(stock, income_statement,form, fp, fy)

}

