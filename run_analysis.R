library(data.table)  
library(dplyr) 

# Download files & unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip")  
unzip(zipfile = "UCI HAR Dataset.zip")  

# Read in data
training <- read.table("train/X_train.txt", header = FALSE)  
test <- read.table("test/X_test.txt", header = FALSE)  
training_subject <- read.table("train/subject_train.txt", header = FALSE, col.names = "subject")  
test_subject <- read.table("test/subject_test.txt", header = FALSE, col.names = "subject")  
activityLabels <- read.table("activity_labels.txt", col.names = c("code", "activity"))  
training_Labels <- read.table("train/y_train.txt", header= FALSE, col.names = "code")  
test_Labels <- read.table("test/y_test.txt", header= FALSE, col.names = "code")  
features <- read.table("features.txt", header= FALSE)  

# Merge train- and test dataset
fullData <- rbind(training, test)  
features$V2 <- as.character(features$V2)  
fullData <- setnames(fullData[, 1:561], features$V2)   
fullSubject <- rbind(training_subject, test_subject)  
fullLabels <- rbind(training_Labels, test_Labels)  
fullData <- cbind(fullSubject, fullLabels, fullData) 

# Mean and standard deviation for each measurement
meanVariables <- fullData[grep("mean", names(fullData))]  
stdVariables <- fullData[grep("std", names(fullData))]  
neededVariables <- cbind(fullData[, 1:2], meanVariables, stdVariables)  

# Descriptive activity names (value: 'activity')
neededVariables$code <- activityLabels[neededVariables$code, 2]  

# Descriptive variable names
names(neededVariables) <- gsub("^t", "time", names(neededVariables))  
names(neededVariables) <- gsub("^f", "fast", names(neededVariables))  
names(neededVariables) <- gsub("Acc", "Acceleration", names(neededVariables))  
names(neededVariables) <- gsub("Gyro", "Gyroscope", names(neededVariables))  
names(neededVariables) <- gsub("Mag", "Magnitude", names(neededVariables))  
names(neededVariables) <- gsub("code", "activity", names(neededVariables))  

# Average of each variable for each activity and each subject
tidyDataset <- neededVariables %>%  
  group_by(subject, activity) %>%  
  summarise_all(mean)  
write.table(tidyDataset, file = "tidyData.txt",row.name=FALSE)