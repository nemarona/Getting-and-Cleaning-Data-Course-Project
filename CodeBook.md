Code Book
=========

This code book describes the variables, the data and all transformations
or work that I performed in order to clean up the data.

Variables and Data
------------------

There are two sets of data:
- X_train.txt: 7352 observations of 561 variables
- X_test.txt: 2947 observations of 561 variables

Those two files are really one big dataset with 10299 observations.

The names of the variables are given in the file "features.txt" (561 rows, two columns).

Each observation (or row) corresponds to a particular subject performing a particular activity.
The list of subjects is given in the files
- subject_train.txt (7352 rows)
- subject_test.txt (2947 rows)

The list of activities is given in the files
- y_train.txt (7352 rows)
- y_test.txt (2947 rows)

Activites are coded as numbers from 1 to 6.
The translation from numbers to the actual name of the activity is given in the file "activity_labels.txt".

Of the 561 variables, we are interested only in those that refer to means and standard deviations,
which are characterized by variable names containing "mean()" or "std()".
We do not include variables such as "fBodyAcc-meanFreq()-X", since these are not time averages but frequency averages,
nor variables such as "angle(X,gravityMean)", since these are actually angles that mean values make with other variables.

Transformations
---------------

The raw data is loaded into R in one data frame containing 10299 observations of 563 variables.
Those are all the observations from the training and testing sets put together,
for all the 561 variables (also called features, measurements), plus two extra columns:
one for the subject ID and other for the activity code.

Activity codes are then replaced by the actual activity names, as given in the file "activity_labels.txt".

Only 66 variable names contain either "mean()" or "std()".
We select only those and discard all the other columns.
The result is a data frame with 10299 observations of 68 variables
(the 66 corresponding to means and standard deviations, plus the two with subject ids and activities).

Finally, we build a second data frame where we compute the means of all 66 variables
grouped according to subject and activity.
Since there are 30 subjects and 6 different activities,
the result is a data frame containing 30*6 = 180 observations of 68 variables.

