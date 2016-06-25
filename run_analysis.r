#
# run_analysis.r
# Pre-requisite: 1) package 'plyr' has been installed
#                2) UCI HAR Dataset is copied to the current working directory
#

library(plyr)

setwd("c:/r")

# Read test and train files
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", colClasses = "numeric")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", colClasses = "integer")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = "integer")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", colClasses = "integer")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses = "integer")

# Read descriptive names for activity labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Replace variable names with feature labels
names(X_test) <- features$V2
names(X_train) <- features$V2

# Add activity labels and subject id as new variables to datasets
X_test$activity <- factor(y_test$V1, levels=activity_labels$V1, labels=activity_labels$V2)
X_test$subject <- subject_test$V1
X_train$activity <- factor(y_train$V1, levels=activity_labels$V1, labels=activity_labels$V2)
X_train$subject <- subject_train$V1

# Merge datasets
merged <- rbind(X_test, X_train)

# Extracts only the measurements on the mean and standard deviation for each measurement
requiredCols <- grep("std\\()|mean|^activity$|^subject$", names(merged), ignore.case=TRUE)

# Keep only wanted columns
filtered <- merged[, requiredCols]

# Create tidy data set with only means (data grouped by subject and activity)
means <- ddply(filtered, c("subject", "activity"), numcolwise(mean))

# Write data file
write.table(means, "tidydata.txt", row.names=FALSE)
