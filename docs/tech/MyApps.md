# Software Development

## Quick Links

[BikeHike Repair Site](https://bikehike.org/how-much-to-repair-macbook-pro-speakers/).

[Find My Mac-EveryMac](https://everymac.com/ultimate-mac-lookup/).

<hr style="height:8px;border-width:0;color:blue;background-color:blue">





## Budget Analysis

**Tools**

Excel (VBA)

SQLite3

**Data Set**

July 2016 through June 2022

<hr style="height:8px;border-width:0;color:blue;background-color:blue">






## 2022-July Summary

Quick note: the *'Classes'* I've been using involve too many sub-catagories: it's become unwieldy. Also, the naming convention was inconsistent and inflexible. So, I'm going with less catagories:

DLXxxx = daily living expenses (food, other consumables - GREEN)

HSHxxx = Household (Maintenance, gardening, large purchases - GREEN)

OTHxxx = Other expenses (Business, transport, donations, hobbies - ORANGE)

BKxxxxx = Bank-based (fees, charges - GREY)

HOLxxxx = Holidays - LILAC

INCxxxx = Revenue (income - BLUE)

LGLxxxx = Fixed expenses (Tax accountant, other legal - BLUE)

MORxxxx = Mortgage-related txns - YELLOW

The approach was to import transactions from ANZ Savings (259), my personal checking (972), credit card (568), home loan (822) and BeyondBank (647) from July 2016 through June 2022 inclusive into one spreadsheet.

* TransNo - Record Number
*	T-Acct - Transaction Account: 
*	T-Date - Date
*	T-Amt - Amount
*	T-Desc - Transaction Description
*	TransCode - Transaction Code

Final column (TransRelated) is a throw-away, exists as a kludge to make sure each row in the export CSV has equal number of columns. Important: *prior to export to CSV, to keep SQLite happy with the date field, change dd/mm/yyyy to yyyy-mm-dd*.

<hr style="height:8px;border-width:0;color:blue;background-color:blue">






## SQL Code

Food items for FY-2016:

``` sql
SELECT TransDate, TransAmt, TransDesc FROM Transactions WHERE TransCode = 'DLXALI' AND TransDate BETWEEN '2016-07-01' AND '2017-06-31' ORDER BY TransDate;
```

Classes:

``` sql
SELECT DISTINCT TransCode FROM Transactions ORDER BY TransCode;
```

## Coding Links

[JSON verification site](https://jsonlint.com/)

[Visual Studio Code SUpport](https://marketplace.visualstudio.com/items?itemName=EXCEEDSYSTEM.vscode-macros)

[C Pearson VBA site](http://www.cpearson.com/excel/ArraysAndRanges.aspx)

[Stack Overflow VBA: don't use Select](https://stackoverflow.com/questions/10714251/how-to-avoid-using-select-in-excel-vba)

[Sphinx: 'ref' usage](https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#ref-role)

[Sphinx: tables](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#tables)

[VS Code](https://code.visualstudio.com/docs/setup/setup-overview)






