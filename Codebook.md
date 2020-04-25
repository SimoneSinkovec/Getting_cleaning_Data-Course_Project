---
title: "Getting Cleaning Data - Course project"
author: "Simone Sinkovec"
date: "4/25/2020"
output:
    html_document:
      keep_md: true
---



# Goal 
Transforming pieces of raw dataset about activities from wearable computing (like Fitbit) into a a tidy dataset using R programming language. To create a tidy dataset, the course structured is with 5 questions (headers after reading in files).

## Load libraries
data.table: renaming variables (setnames)  
dplyr: tidying dataset to 'tidyDataset'

```r
library(data.table)  
library(dplyr)  
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:data.table':
## 
##     between, first, last
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```
  
## Download & read files  
A bunch of files will be downloaded by link below. Some only give extra information about the dataset: 
README.txt tells how the data is structured.  
features_info.txt contains extra info about how the variables can be read.  
Some files give extra information that can be modified in the dataset. Eight files are needed to be read in R for this project (see below). They can all be linked together:  
X_train & Y_train: dataset of measurements.  
subject_train, subject_test: data about numbering subjects to dataset.  
y_train, y_test: number 1 to 6 that can be linked to activity_labels.  
activity_labels: two variables (1:6 = code; linked to 6 activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).  
features.txt: a list of 561 names of variables.  

```r
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip")  
unzip(zipfile = "UCI HAR Dataset.zip")  

training <- read.table("train/X_train.txt", header = FALSE)  
test <- read.table("test/X_test.txt", header = FALSE)  
training_subject <- read.table("train/subject_train.txt", header = FALSE, col.names = "subject")  
test_subject <- read.table("test/subject_test.txt", header = FALSE, col.names = "subject")  
activityLabels <- read.table("activity_labels.txt", col.names = c("code", "activity"))  
training_Labels <- read.table("train/y_train.txt", header= FALSE, col.names = "code")  
test_Labels <- read.table("test/y_test.txt", header= FALSE, col.names = "code")  
features <- read.table("features.txt", header= FALSE)  
```
  
# Merges the training and the test sets to create one data set.  
First make one dataset by merging the training- en test dataset with rbind().
Rename variables by setnames() requires character vector. 
Merge subject data into one dataset in same order the dataset was ordered.
Merge labels for both datasets in same order.
cbind() all 3 new datasets.

```r
fullData <- rbind(training, test)  
features$V2 <- as.character(features$V2)  
fullData <- setnames(fullData[, 1:561], features$V2)   
  fullSubject <- rbind(training_subject, test_subject)  
  fullLabels <- rbind(training_Labels, test_Labels)  
    fullData <- cbind(fullSubject, fullLabels, fullData) 
```
  
# Extracts only the measurements on the mean and standard deviation for each measurement. 
Grep uses the names function to extract relevant information.
After the variables with both words ("mean" and "std) are filtered out, they need to be merge to a new dataset, together with the first two columns of 'fullData'. Those columns are needed to answer the fourth question.

```r
meanVariables <- fullData[grep("mean", names(fullData))]  
stdVariables <- fullData[grep("std", names(fullData))]  
  neededVariables <- cbind(fullData[, 1:2], meanVariables, stdVariables)  
```
  
# Uses descriptive activity names to name the activities in the data set  
The code in the dataset activityLabels can be matched with code in train- en and testLabels (=fullLabels). They are merged earlier this datase
Use the variable 'code' of 'neededVariables' to set the names of features.txt (loaded as activityLabels)

```r
neededVariables$code <- activityLabels[neededVariables$code, 2]  
```
  
# Appropriately labels the data set with descriptive variable names. 
features_info.txt explaines what abbreviations are use in the variable names and what they mean. Since appropriate labels doesn't contain abbreviations, gsub is used to make them more explicit. The '^' is used to only select 't' and 'f' when they are at the beginning of the variable, to avoid confusion in a lot of variables.

```r
names(neededVariables) <- gsub("^t", "time", names(neededVariables))  
names(neededVariables) <- gsub("^f", "fast", names(neededVariables))  
names(neededVariables) <- gsub("Acc", "Acceleration", names(neededVariables))  
names(neededVariables) <- gsub("Gyro", "Gyroscope", names(neededVariables))  
names(neededVariables) <- gsub("Mag", "Magnitude", names(neededVariables))  
names(neededVariables) <- gsub("code", "activity", names(neededVariables))  
```
  
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
As learned in this course dplyr is used by chaining, to first use functions over the value of 'subject', and after that over 'activity'. The function to be used to get average is mean(). This all will give an ascending dataset that gives the mean for each variable per subject, per activity.

```r
tidyDataset <- neededVariables %>%  
  group_by(subject, activity) %>%  
  summarise_all(mean)  
write.table(tidyDataset, file = "tidyData.txt",row.name=FALSE)
```
