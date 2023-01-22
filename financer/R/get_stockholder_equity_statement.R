

income_statement <- "124100 - Statement - Statement of Income"
balance_sheet <- "104000 - Statement - Statement of Financial Position, Classified"
cash_flow_statement <- "152200 - Statement - Statement of Cash Flows"

stockholder_equity_statement <- "148600 - Statement - Statement of Shareholders' Equity"



#' @export
get_statement_of_cashflows <- function(stock, fy, form="10-K", fp="FY" ){

  financial_statement(stock,cash_flow_statement,form, fp, fy)

}


