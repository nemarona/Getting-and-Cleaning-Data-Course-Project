## This is the R script required for the Course Project from the Getting and Cleaning Data course

## We assume that the data have been unzipped into the current working directory.
## cd into the "UCI HAR Dataset" directory
setwd("UCI HAR Dataset")

## Load dplyr package
library("dplyr")

## The names of the 561 variables are contained in the features.txt file
## Read file and store variable names in varnames character vector
varnames <- read.table("features.txt", colClasses = c("integer", "character"), nrows = 561)
varnames <- varnames$V2

## Define the number of rows to be read from each data file
## The full data set is extracted with nrows.train <- 7352, nrows.test <- 2947
nrows.train <- 7352
nrows.test <- 2947

## Read subjects' IDs
subjects.train <- tbl_df(read.table("train/subject_train.txt", col.names = "subject", nrows = nrows.train))
subjects.test <- tbl_df(read.table("test/subject_test.txt", col.names = "subject", nrows = nrows.test))

## Read activities
activities.train <- tbl_df(read.table("train/y_train.txt", col.names = "activity", nrows = nrows.train))
activities.test <- tbl_df(read.table("test/y_test.txt", col.names = "activity", nrows = nrows.test))

## Read datasets into data frames in R
data.train <- tbl_df(read.table("train/X_train.txt", col.names = varnames, nrows = nrows.train))
data.test <- tbl_df(read.table("test/X_test.txt", col.names = varnames, nrows = nrows.test))

## Add the subject and activity columns
data.train <- bind_cols(subjects.train, activities.train, data.train)
data.test <- bind_cols(subjects.test, activities.test, data.test)

## Join all data in one data frame
data <- bind_rows(data.train, data.test)

## Each activity is coded as a number. Retrieve the names:
activities <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
activities <- activities$V2

## Use activity names (gives an error if not all activities are present in the data)
data$activity <- factor(data$activity, labels = activities)

## Remove all intermediate data frames
rm(subjects.train, subjects.test, activities.train, activities.test, data.train, data.test)

## Determine which variables refer to mean() or std()
## We'll add two columns at the beginning and we want to keep them, so we add two to every element of the index vectors
which.mean <- grep("mean()", varnames, fixed = TRUE) + 2
which.std <- grep("std()", varnames, fixed = TRUE) + 2
which.vars <- sort(c(1, 2, which.std, which.mean))
nvars <- length(which.vars)

## Select columns with "mean" or "std" in their names
data <- data %>%
    select(which.vars)

## Make tidy data set with average values for each variable, grouped by subject and activity
tidy <- data %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))

## Export tidy data frame as a text file
write.table(tidy, "../tidydataset.txt", row.names = FALSE)

##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
