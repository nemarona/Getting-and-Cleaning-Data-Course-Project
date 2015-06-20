README
======

This README.md file explains how the "run_analysis.R" script works.

Preliminaries
-------------

The script assumes that the zip file with the data sits in the current working directory
and that it has been fully unzipped, extracting all files.

"UCI HAR Dataset" is set as the new working directory.

Loading the data into R
-----------------------

We first load the `dplyr` package.

The names for the 561 variables of the data set are extracted from the file "features.txt"
and saved as as character vector, `varnames`.

As a security check, and also to speed up test runs of the script,
we define two variables with the number of rows to be read from the "X_train.txt" and "X_test.txt" files:
```
nrows.train <- 7352
nrows.test <- 2947
```
These variables can be set to lower values for test runs of the script.
However, if they're set too low then problems arise, because not every activity will be present
in the observations and the translation from activity codes into activity names will fail.
We recommend setting them to at least 1000 each.

The script then reads the subject IDs and saves them into two data frames: `subjects.train` and `subjects.test`.
Only `nrows.train` and `nrows.test` rows are read from each file.
The single column in each of these data frames is given the name "subject".

A similar operation is performed then with the activity codes,
which are read into the `activities.train` and `activities.test` data frames.
Again, only `nrows.train` and `nrows.test` rows are read from each file.
The single column in each of these data frames is given the name "activity".

The actual data sets are then read into R as two data frames, `data.train` and `data.test`.
Only `nrows.train` and `nrows.test` rows are read from each file.
The option `col.names = varnames` is passed to the `read.table()` function to assing column names according to the "features.txt" file.
Since R considers parentheses, dashes, and others to be invalid characters to be used for column names in a data frame,
these get automatically replaced by dots; e.g., `tBodyAcc-mean()-X` gets replaced by `tBodyAcc.mean...X`.
We have made no attempt to fix this.

The script then calls the `bind_cols()` function from the `dplyr` package
to insert subject IDs and activity codes as the new first and second columns of the `data.train` and `data.test` data frames.

A call to the `bind_rows()` function from the `dplyr` package
merges the two data frames into one, called simply `data`, containing `nrwos.train + nrows.test`
(which equals 10299 when the full data set is loaded into R) observations of 563 variables.

The instructions require that activities are identified by their names, not their numbers.
To accomplish this, the script fetches the names from the "activity_labels.txt" into a character vector called `activities`.
Then, the "activity" column of the `data` data frame is turned into a factor,
with the activity names as labels.

As a final step, all intermediate data frames are removed from memory:
```
rm(subjects.train, subjects.test, activities.train, activities.test, data.train, data.test)
```

Selecting and processing data
-----------------------------

Since we're only interested in variables containing means and standard deviations,
we look for "mean()" and "std()" in the `varnames` character vector.
Using `grep`, we define two indices vectors, `which.mean` and `which.std`,
with the column *numbers* of the variables that include "mean()" and "std()" in their names, respectively.
Each of these vectors has 33 entries, making a grand total of 66 columns containing means and standard deviations.
From these, we build a single indices vector, `which.vars`, which contain all of the above, sorted,
shifted by two, plus the indices 1 and 2, where the subject IDs and activities will be stored.

Selecting the desired columns is now a matter of using the `select()` function from the `dplyr` package:
```
data <- data %>% select(which.vars)
```
Here we make use of the `%>%` command, which builds pipelines of actions that are applied consecutively.
The resulting data frame contains 10299 observations of 68 variables
(the 66 columns with means and standard deviations plus subject IDs and activities).

We group this data frame by subject and activity and take the mean of each column:
```
tidy <- data %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))
```
The `tidy` data frame that results contains 180 observations of 68 variables.
These 180 observations correspond to six activities for each of the 30 subjects.

The `tidy` data frame is finally written into the "tidydataset.txt" text file
using the `write.table` function with the `row.names = FALSE` option.
