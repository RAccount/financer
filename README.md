# Finance R

Welcome to the financial analysis package, a set of functions written in R for analyzing financial data. With this package, you can easily import, clean, and manipulate financial data from edgar, as well as visualize and model it.

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
