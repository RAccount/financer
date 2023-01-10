# Finance R

Welcome to the financial analysis package, a set of functions written in R for analyzing financial data. With this package, you can easily import, clean, and manipulate financial data from edgar, as well as visualize and model it.

## Introduction


Financial statement analysis is an important aspect of understanding the financial performance and health of a company. One important source of financial information for publicly traded companies is the Securities and Exchange Commission's EDGAR system, which stands for Electronic Data Gathering, Analysis, and Retrieval. The EDGAR system provides a wealth of financial information in the form of financial statements filed by publicly traded companies. However, the process of analyzing this information can be time-consuming and difficult, especially when done manually. This is where an R package for analyzing financial statements from SEC-Edgar can be extremely useful.

### Background:

R is a popular programming language for data analysis and statistics, and it has a large and active community of users and developers. There are already many R packages available for financial analysis, but most of them focus on specific aspects of financial analysis, such as time series analysis or financial modelling. While these packages can be useful, they are not well-suited for analyzing financial statements from SEC-Edgar.

### Purpose:

The purpose of a new R package for analyzing financial statements from SEC-Edgar would be to make it easier for analysts and researchers to access, download, and analyze financial information from the EDGAR system. The package would provide a set of tools for:

Retrieving financial statements from SEC-Edgar in a programmatic manner
Parsing and cleaning the financial statement data into simple data structures 
Providing useful financial metrics and ratios such as profitability, liquidity and solvency.
Visualizing the financial statement data in an interactive way.




## Installation


To install the financial analysis package, you will need to have the devtools package installed. If you do not have devtools installed, you can install it by running the following command:

`install.packages("devtools")`

Once you have devtools installed, you can install the financial analysis package by running the following command:

`devtools::install_github("RAccount/financer")`

## Usage

To use the financial analysis package, you will need to load it into your R environment. You can do this by running the following command:

`library(financer)`

Once the package is loaded, you can access the various functions by calling them directly. For example, to get the balance sheet of an equity, you can simply run

`get_balance_sheet()`

You can also use the help function to get more information on each function, including its arguments and usage examples. For example, to get more information on the import_data function, you can run `help(get_balance_sheet)`.

## Functions

Here is a list of the functions included in the financial analysis package:

-   `get_balance_sheet`: This function imports the balance sheet of the equity from the 10-Q.

-   `get_income_statement`: This function imports the income statement of the equity from the 10-Q.

-   `get_statement_of_cashflows`: TThis function imports the cashflow sheet of the equity from the 10-Q.

-   `get_stockholder_equity_statement`: This function imports the balance sheet of the equity from the 10-Q.

## Contributions

We welcome contributions to the financial analysis package. If you would like to contribute, please fork the repository and submit a pull request. Please make sure to follow the code style guidelines and run the tests before submitting the pull request.

## License

The financial analysis package is released under the MIT License.
