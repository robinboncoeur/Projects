# Python including Pip

## Pip Installs

### yt-dlp

To download/install **or** update:

```bash
	pip3 install yt-dlp
```

When you get this **ERROR: Did not get any data blocks** invoke:

```bash
	yt-dlp --list-formats https://www.youtube.com/watch?v=NameOfFile
```

See which one will allow download. Youmay end up with a .3gp file.

<hr style="height:2px;border-width:0;color:gray;background-color:gray">






### Project: Roster App

Name of application:

- rosterapp21s9453

[Credentials set up here](https://console.developers.google.com/apis/credentials?showWizardSurvey=true&project=rosterapp21s9453):

- https://console.developers.google.com/apis/credentials?showWizardSurvey=true&project=rosterapp21s9453

In google drive, set things up to be able [to access with Python this way](https://www.twilio.com/blog/2017/02/an-easy-way-to-read-and-write-to-a-google-spreadsheet-in-python.html).

Installed gspread and oauth2client via pip3:

```bash
    pip3 install gspread oauth2client
```

<hr style="height:2px;border-width:0;color:gray;background-color:gray">





### Python Video Tutorials

[Corey Schafer's YouTube Series](https://www.youtube.com/watch?v=YYXdXT2l-Gg&list=PL-osiE80TeTskrapNbzXhwoFUiLCjGgY7)

[Mouse vs Python Series Python 101](https://www.youtube.com/watch?v=k0zZcnZHYAo&list=PLN0iJDXT7K2u3xVle4-9N1_DLqIh0sfys)

<hr style="height:2px;border-width:0;color:gray;background-color:gray">




## Replacing VBA with Python

### VBA2Python Simple Guide

As someone who has been working with Excel for many years, I know that the idea of learning things you can already do in Excel/VBA in a completely new environment like Python doesn’t sound so exciting. However, all the benefits that the Python environment offers make this worth it. For this reason, I came up with a useful and simple guide I wish I had when I switched from Excel to Python.

In this article, we’ll use Python’s Pandas and Numpy library to replace many Excel functions you probably used in the past.

Table of Contents:

1. The Dataset

2. Sum, Average, Max, Min, Count

  - Columns (e.g. sum a column)

  - Rows (e.g. sum a row)

3. IF

  - Replace IF with np.where

  - Replace nested IF with np.select

4. SumIf, CountIf, AverageIf

  - One condition (select a column with square brackets [ ] )

  - Two or more conditions::  (select columns and use & or | )

5. Basic Data Cleaning

  - Change the case of text with .str.lower, .str.upper or .str.title

  - Extract text in a column with .str.extract

  - Identify whether a cell is empty with the .isnull method

6. Vlookup

  - Find an element with .loc[ ]

  - Merge two tables with pd.merge or pd.concat

7. Pivot Table

  - Use the .pivot_table method

8. Replace Excel Graphs with Python’s Matplotlib or Seaborn

---

**The Dataset**

In this guide, we’ll use an Excel file that has a .csv format, which is typically used when working with datasets. The dataset consists of the marks secured by students in various subjects and will help us easily switch from Excel spreadsheets to Python’s dataframes. You can download this data on Kaggle or on my Github (check the datasets folder).

To start with this guide, let’s import the Pandas and Numpy libraries.

- import pandas as pd
- import numpy as np

Note: If you don’t have those libraries installed in Python, you can easily install them by writing pip install pandas and pip install numpyon your terminal or command prompt.

With this, we can take a first look at the data. To do so, we use pd.read_csv(). Make sure that the CSV and your Python script are located in the same place (same path).

- df_excel = pd.read_csv('StudentsPerformance.csv')
- df_excel

Once we read this CSV file, we give it a name. In this case, I named it df_excel. df stands for dataframe and it’s the typical name given after reading a CSV file. After running the code below, we obtain the following output.
This looks similar to an Excel spreadsheet, but in this format, it’ll be easier to wrangle the data. Now I’ll show you in Python how to do some common functions you probably used in Excel.

---

**Sum, Average, Max, Min, Count**

Excel’s popular functions can be easily replaced with Pandas methods. Let’s take a look.

- Columns (e.g. sum a column)

If we want to get most of the functions listed above, we use the .describe() method.

- df_excel.describe()

As you can see, with this we get the count, mean, max, and min values of all numerical columns.

However, if we want to select a specific row, we first select with square brackets [ ] and then use the method we need (.sum(), .mean(), etc.). For example, let’s calculate the average of math scores.

- In [1]: df_excel['math score'].mean()
- Out [1]: 66.089

These are some of the other methods you can use.

```python
  df_excel['math score'].mean()
  df_excel['math score'].max()
  df_excel['math score'].min()
  df_excel['math score'].count()
  Rows (e.g. sum a row)
```
  
Now let’s say we want to calculate the average of the 3 marks (math, reading, and writing). Those values are within different columns, so we have 2 options. We can either sum each column

```python
  df_excel['average'] = (df_excel['math score'] + df_excel['reading score'] + df_excel['writing score'])/3
```

Or use the method we used before to sum values within a column, but in this case, we add axis=1

```python
  df_excel['average'] = df_excel.mean(axis=1)
```

We also added a new column [‘average’] when calculating the average. We’ll use this new column for the next section (IF).

Keep in mind that in this example we could use the second option because the only numerical values are within the desired columns ( (math, reading, and writing scores). If there was an additional column we don’t want to consider in the sum, we should only use the first option. In case we want to count the number of specific data within a column, we can use the .value_counts() method.

- In [2]: df_excel['gender'].value_counts()
- Out [2]: 
- female    518
- male      482

----

**IF**

We can easily replace Excel’s IF function by using Numpy.

**Replace IF with np.where**

Let’s imagine we want to know whether a student has passed or failed an exam and create a new column with that information. We can easily do that with the following code.

```python
  df_excel['pass/fail'] = np.where(df_excel['average'] > 70, 'Pass', 'Fail')
```

As you can see np.where() needs 3 arguments — the condition, the value if the condition is True, and the value if the condition is False.

**Replace nested IF with np.select**

Let’s imagine we want to give grades from A to F based on the scores obtained. In this case, we have more than 2 values, so we use np.select(). np.select() needs two arguments — a list of conditions and a list of values. A list in Python is represented by the square brackets [ ]:

```python
  conditions = [
      (df_excel['average']>=90),
      (df_excel['average']>=80) & (df_excel['average']<90),
      (df_excel['average']>=70) & (df_excel['average']<80),
      (df_excel['average']>=60) & (df_excel['average']<70),
      (df_excel['average']>=50) & (df_excel['average']<60),
      (df_excel['average']<50),
  ]

  values = ['A', 'B', 'C', 'D', 'E', 'F']
```

Keep in mind that each condition should be within parenthesis. Now we use the .select() method and assign it to a new [‘grades’] column.

```python
  df_excel['grades'] = np.select(conditions, values)
```

Now the first 5 rows of the output should look like this.

We picked these 3 columns with double square brackets df_excel[[‘average’, ‘pass/fail’, ‘grades’]] and the first 5 rows can be displayed with the .head() method.

<hr style="height:2px;border-width:0;color:gray;background-color:gray">





---

**SumIf, CountIf, AverageIf**

To sum, count, or calculate the average based on a condition, in Python, we first filter out values and then make the calculation.

**One condition (select a column with square brackets [ ])**

Let’s imagine we want to sum the scores for only the female gender. To do so, first, we write the condition df_excel[‘gender’] == ‘female’ and then. we select that condition inside the df_excel frame by using square brackets [ ]

```python
  df_female = df_excel[df_excel['gender'] == 'female']
```

We selected only the female gender and placed it in a dataframe called df_female. Now we can perform any calculation we saw in the “Sum, Average, Max, Min, Count” section. Two or more conditions: 

```python
  ( select columns and use & or | )
```

If we have two or more conditions, the code will look similar to the one above, but with some changes. Let’s imagine we want to calculate the score of females within Group B (‘race/ethnicity’):

```python
  df_sumifs = df_excel[(df_excel['gender'] == 'female') & (df_excel['race/ethnicity'] == 'group B')]
```

Since there are 2 conditions we could use & | that represents and/or respectively. Keep in mind that each condition should be within parenthesis. Now let’s sum the scores.

```python
  df_sumifs = df_sumifs.assign(sumifs = df_sumifs['math score'] + df_sumifs['reading score'] + df_sumifs['writing score'])
```

In this case, I used the .assign() method to show you another way to create a new column while doing calculations.



---

**Basic Data Cleaning**

We’re going to check a few methods used for data cleaning. In case you want to know all the methods used for cleaning data, check the complete guide I wrote on how to clean and prepare data in Python. We’ll continue using the df_excel frame we defined before.

---

**Change the case of text with .str.lower, .str.upper or .str.title**

To access the strings contained in a column, we use .str Then we can change the case of text with the following:

```python
  df_excel['gender'].str.title()
  df_excel['gender'].str.upper()
  df_excel['gender'].str.title()
```

To save the values we can overwrite a column like in the code below.

```python
  df_excel['gender'] = df_excel['gender'].str.title()
```

But in this case, we’ll leave the values as it is.

---

**Extract text in a column with .str.extract**

We can easily extract text from a column with .str.extract. In addition to that, if we want to extract specific patterns of a text we can use regular expressions. Let’s imagine we want to extract only the words in upper case within the column ‘race/ethnicity’ (e.g., “B” from “Group B”). To do so, we write the following code.

```python
  df_excel['race/ethnicity'].str.extract(r'([A-Z])')
```

In this case, we used the regular expression r'([A-Z])’ where [A-Z] indicate words in upper case, while the parenthesis () is necessary to pick the desired pattern. Regular expressions might look intimidating, but they’re simpler than you think. In the link below, you’ll find a simple guide I made to easily learn regular expressions.

---

**Identify whether a cell is empty with the .isnull method**

To replace Excel’s COUNTA, in Python we can use .isnull() to find empty values.

```python
  df_excel[df_excel['gender'].isnull()]
```

In this case, there are no empty values so the result will be an empty dataframe.

---

**Vlookup**

To find elements as Vlookup does in Excel, we’re going to use .loc[], .merge() or .concat() based on the problem we want to solve. Only, for these examples, we’re going to work with 2 Excel spreadsheets. The first is the same “StudentsPerformance” we’ve been working with so far, while the second is a CSV file named “LanguageScore” that I created with random id and language score values (you can find this file on my Github). Let’s read both files with pd.read_csv() as we did before.

```python
  excel_1 = 'StudentsPerformance.csv'
  excel_2 = 'LanguageScore.csv'
  df_excel_1 = pd.read_csv(excel_1)
  df_excel_2 = pd.read_csv(excel_2)
```

Now we’re going to create an id column on df_excel_1 so it has a column in common with df_excel_2. To do so, we run the following code.

```python
  df_excel_1 = df_excel_1.reset_index()
  df_excel_1 = df_excel_1.rename(columns={'index':'id'})
```

As you can see, I made an id column based on the index. reset_index() gets rid of the index by adding it as a column. You can drop the index doing .reset_index(drop=True) but in this case, I’ll rename this new index column by using the .rename() method. With this, we have a new id column.

---

**Find an element with .loc[ ]**

Finding an element using Pandas is as easy as writing .loc[] . Inside [] we have to include the row and column label. Ler’s find the information related to row 100.

```python
  In [3]: df_excel_1.loc[100, ]
  Out [3]:
  id                                      100
  gender                                 male
  race/ethnicity                      group B
  parental level of education    some college
  lunch                              standard
  test preparation course                none
  math score                               79
  reading score                            67
  writing score                            67
```

We can also set conditions. For example, we want to get the math score for the student with id equal to 100.


In [3]: df_excel_1.loc[df_excel_1['id']==100, 'math score']
Out [3]:
100    79
Name: math score, dtype: int64

This means that the student with id 100 got score 79 in math.

---

**Merge two tables with pd.merge or pd.concat**

Let’s imagine you want to add the language score of all students who gave the exam. In this case, we use pd.merge(). This requires that 2 tables have 1 common column. In this case, this column is the id column.

```python
  df_excel_3 = pd.merge(df_excel_1, df_excel_2, on='id', how='left')
  df_excel_3['language score'].fillna('0', inplace=True)
```

Above you can see that another argument is needed (how). This indicates how the merge is performed. Left and right will havedf_excel_1 and df_excel_2 as a reference for the final result, while inner will only give the common data inside the id column.

You can also use pd.concat() for the same purposes, but you have to set the id as index before concatenating frames and include the frames as lists (within brackets [])

```python
  df_excel_3 = pd.concat(
   [df_excel_1.set_index('id'), df_excel_2.set_index('id')], axis=1
  )
  df_excel_3['language score'].fillna('0', inplace=True)
  df_excel_3
```

All the values that don’t match will receive a NaN, but we can replace it with any value by using the.fillna() method.



---

**Pivot Table**

Using the .pivot_table method, the Pandas’ pivot_table method works similarly to the one you find in Excel. Let’s imagine we want to obtain the math and writing score of all the groups inside the race/ethnicity column.

```python
  df_excel = pd.read_csv('StudentsPerformance.csv')
  df_pivot = df_excel.pivot_table(index='race/ethnicity', values=['math score', 'writing score'], aggfunc='mean')
  df_pivot
```

The index argument will group the ‘race/ethnicity’ column, while the values argument will take the numerical values to show. Finally, the calculations are made by the aggfunc. In this case, we pick the mean. As a result, we obtain the following pivot table.


---

**Replace Excel Graphs with Python’s Matplotlib or Seaborn*

Python contains different libraries to make visualizations as good as those Excel offers. Let’s make a simple barplot based on the results of df_pivot we created above. First, we import matplotlib and then we use plt.bar()

```python
  import matplotlib.pyplot as plt
  df_plot = df_pivot.reset_index()
  plt.bar(df_plot['race/ethnicity'], df_plot['math score'])
  plt.show()
```

The first argument of plt.bar() is the label and the second is the numeric value. Then we display the results with plt.show()

There are many things you can do in a Python plot such as adding labels to the graph, titles, customizing the size of the figure and colors, but that’s a whole new topic. I already made a guide to make beautiful visualizations in Python which includes lineplots, barplot, piecharts, histograms, boxplots, etc. Check it out in the link below.

That’s it! Now you’re ready to take advantage of all the benefits Python and Pandas offers! All the code used in this article is available on my Github.

<hr style="height:2px;border-width:0;color:gray;background-color:gray">






### Mega-Replace

Microsoft Excel and Word are without a shred of doubt the two most abundantly used software in the corporate and non-corporate world. They are practically synonymous with the term ‘work’ itself. Often times, not a week goes by without us firing up the combination of the two and one way or another putting their goodness to use. While for the average daily purpose automation would not be solicited, there are times when automation can be a necessity. Namely, when you have a multitude of charts, figures, tables and reports to generate, it can become an exceedingly tedious undertaking if you choose the manual route. Well it doesn’t have to be that way. There is in fact a way to create a pipeline in Python where you can seamlessly integrate the two to produce spreadsheets in Excel and then transfer the results to Word to generate a report virtually instantaneously.

**Openpyxl**

Meet Openpyxl, arguably one of the most versatile bindings in Python that makes interfacing with Excel quite literally a stroll in the park. Armed with it you can read and write all current and legacy excel formats i.e. xlsx and xls. Openpyxl allows you to populate rows and columns, execute formulae, create 2D and 3D charts, label axes and titles, and a plethora of other abilities that can come in handy. Most importantly however, this package enables you to iterate over an endless numbers of rows and columns in Excel, thereby saving you from all that pesky number crunching and plotting that you had to do previously.

**Python-docx**

And then comes along Python-docx, this package is to Word what Openpyxl is to Excel. If you haven’t already studied their documentation, then you should probably take a look. Python-docx is without exaggeration one of the most simplest and most self-explanatory toolkits I have worked with ever since I started working with Python itself. It allows you to automate document generation by inserting text, filling in tables and rendering images in to your report automatically without any overhead whatsoever.

Without further ado let’s create our very own automated pipeline. Go ahead and fire up Anaconda (or any other IDE of your choice) and install the following packages:

```bash
  pip install openpyxl
  pip install python-docx
```

Initially we’ll load an Excel workbook that has already been created (shown below):

```python
  workbook = xl.load_workbook('Book1.xlsx')
  sheet_1 = workbook['Sheet1']
```

Subsequently, we’ll iterate over all of the rows in our spreadsheet to compute and insert the values for power by multiplying current by voltage:

```python
  for row in range(2, sheet_1.max_row + 1):
      current = sheet_1.cell(row, 2)
      voltage = sheet_1.cell(row, 3)
      power = float(current.value) * float(voltage.value)
      power_cell = sheet_1.cell(row, 1)
      power_cell.value = power
```

Once that is done, we will use the calculated values for power to generate a line chart that will be inserted into the specified cell as shown below:

```python
  values = Reference(sheet_1, min_row = 2, max_row = sheet_1.max_row, min_col = 1, max_col = 1)
  chart = LineChart()
  chart.y_axis.title = 'Power'
  chart.x_axis.title = 'Index'
  chart.add_data(values)
  sheet_1.add_chart(chart, 'e2') 
  workbook.save('Book1.xlsx')
```

Automatically generated Excel spreadsheet.

---

**Extracting Chart**

Now that we have generated our chart, we need to extract it as an image so that we can use it in our Word report. First we’ll declare the exact location of our Excel file and also where the output chart image should be saved:

```python
  input_file = "C:/Users/.../Book1.xlsx"
  output_image = "C:/Users/.../chart.png"
```

Then access the spreadsheet using the following method:

```python
  operation = win32com.client.Dispatch("Excel.Application")
  operation.Visible = 0
  operation.DisplayAlerts = 0
  workbook_2 = operation.Workbooks.Open(input_file)
  sheet_2 = operation.Sheets(1)
```

Subsequently, you can iterate over all of the chart objects in the spreadsheet (if there are more than one) and save them in the specified location as such:

```python
  for x, chart in enumerate(sheet_2.Shapes):
      chart.Copy()
      image = ImageGrab.grabclipboard()
      image.save(output_image, 'png')
      pass
  workbook_2.Close(True)
  operation.Quit()
```

Now that we have our chart image generated, we must create a template document that is basically a normal Microsoft Word Document (.docx) formulated exactly in the way we want our report to look like, including typefaces, font sizes, formatting and page structure. Then all we need to do is to create placeholders for our automated content i.e. table values and images, and declare them with variable names as shown below.

---

**Microsoft Word document template**

Any automated content can be declared inside a pair of double curly brackets {{variable_name}}, including text and images. For tables, you need to create a table with a template row with all the columns included, and then you need to append one row above and one row below with the following notation. First row:

```python
  {%tr for item in variable_name %}
```

Last row:

```python
  {%tr endfor %}
```

The variable names are:

- **table_contents** : the Python dictionary that will store our tabular data
- **Index** : the dictionary keys (first column)
- **Power | Current | Voltage** : the dictionary values (second, third and fourth columns)

Then we import our template document into Python and create a dictionary that will store our table’s values:

```python
  template = DocxTemplate('template.docx')
  table_contents = []
  for i in range(2, sheet_1.max_row + 1):
      table_contents.append({
          'Index': i-1,
          'Power': sheet_1.cell(i, 1).value,
          'Current': sheet_1.cell(i, 2).value,
          'Voltage': sheet_1.cell(i, 3).value
          })
```

Next we‘ll’ import the chart image that was previously produced by Excel and will create another dictionary to instantiate all of the placeholder variables declared in the template document:

```python
  image = InlineImage(template,'chart.png',Cm(10))
  context = {
      'title': 'Automated Report',
      'day': datetime.datetime.now().strftime('%d'),
      'month': datetime.datetime.now().strftime('%b'),
      'year': datetime.datetime.now().strftime('%Y'),
      'table_contents': table_contents,
      'image': image
      }
```

And finally we’ll render the report with our table of values and chart image:

```python
  template.render(context)
  template.save('Automated_report.docx')
```

---

**Results**

And there you go, an automatically generated Microsoft Word report with numbers and a chart created in Microsoft Excel. And with that you have a fully automated pipeline that can be used to create as many tables, charts and documents as you could possibly ever need.

```python
  import openpyxl as xl
  from openpyxl.chart import LineChart, Reference
  import win32com.client
  import PIL
  from PIL
  import ImageGrab, Image
  import os
  import sys
  from docx.shared import Cm
  from docxtpl import DocxTemplate, InlineImage
  from docx.shared import Cm, Inches, Mm, Emu
  import random
  import datetime
  import matplotlib.pyplot as plt	
	
  ######## Generate automated excel workbook ########
  workbook = xl.load_workbook('Book1.xlsx')
  sheet_1 = workbook['Sheet1']
  
  for row in range(2, sheet_1.max_row + 1):
    current = sheet_1.cell(row, 2)
    voltage = sheet_1.cell(row, 3)
    power = float(current.value) * float(voltage.value)
    power_cell = sheet_1.cell(row, 1)
    power_cell.value = power
    values = Reference(sheet_1, min_row = 2, max_row = sheet_1.max_row, min_col = 1, max_col = 1)
    chart = LineChart()
    chart.y_axis.title = 'Power'
    chart.x_axis.title = 'Index'
    chart.add_data(values)
    sheet_1.add_chart(chart, 'e2')
    workbook.save('Book1.xlsx')	
	
  
  ######## Extract chart image from Excel workbook ########	
  input_file = "C:/Users/.../Book1.xlsx"
  output_image = "C:/Users/.../chart.png"
  operation = win32com.client.Dispatch("Excel.Application")
  operation.Visible = 0
  operation.DisplayAlerts = 0
  workbook_2 = operation.Workbooks.Open(input_file)
  sheet_2 = operation.Sheets(1)
  
  for x, chart in enumerate(sheet_2.Shapes):
    chart.Copy()
    image = ImageGrab.grabclipboard()
    image.save(output_image, 'png')
    pass
  
  workbook_2.Close(True)
  operation.Quit()

  
  ######## Generating automated word document ########	
  template = DocxTemplate('template.docx')
  
  #Generate list of random values
  table_contents = []
  
  for i in range(2, sheet_1.max_row + 1):
    table_contents.append({
      'Index': i-1,
      'Power': sheet_1.cell(i, 1).value,
      'Current': sheet_1.cell(i, 2).value,
      'Voltage': sheet_1.cell(i, 3).value	76
    })

    #Import saved figure
  image = InlineImage(template,'chart.png',Cm(10))

  #Declare template variables
  context = {
    'title': 'Automated Report',
    'day': datetime.datetime.now().strftime('%d'),
    'month': datetime.datetime.now().strftime('%b'),
    'year': datetime.datetime.now().strftime('%Y'),
    'table_contents': table_contents,
    'image': image
  }
  #Render automated report
  template.render(context)
  template.save('Automated_report.docx')  
```

<hr style="height:2px;border-width:0;color:gray;background-color:gray">

