---
title: "Getting & Cleaning Data - Course Project - README"
author: "Simone Sinkovec"
date: "4/25/2020"
output:
    html_document:
      keep_md: true
---

# Getting and Cleaning data - Course Project  
Transforming pieces of raw dataset about activities from wearable computing (like Fitbit) into a a tidy dataset using R programming language. There are 2 linkes that can be used to understand the dataset:  
Dataset : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
Full description of datacollection and dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

## Files  
Via dataset-link, a bunch of files will be downloaded.  
Some only give extra information about the dataset:  
- README.txt tells how the data is structured.  
- features_info.txt contains extra info about how the variables can be read.  

Some files give extra information that can be modified in the dataset. Eight files are needed to be read in R for this project (see below). They can all be linked together:  
- X_train & Y_train: dataset of measurements.  
- subject_train, subject_test: data about linking specific subjects to dataset.  
- y_train, y_test: number 1 to 6 that can be linked to activity_labels.  
- activity_labels: two variables (1:6 = code; linked to 6 activities).  
- features.txt: a list of 561 names of variables.  
  
## Structure of tidying data  
To create a tidy dataset, the course project is structured with 5 questions:  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

## Additional files
Files that help understand the analysis is:  
- Codebook.md: describes the variables, the data, and any transformations or work that I performed to clean up the data.
- run_analysis.r: code for tidying data.
