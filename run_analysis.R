# Creator id: CHEN YANG
# Here are the data for the project:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# 1.Merges the training and the test sets to create one data set
#set current working directory
setwd("/Users/Chen/RStudio_working_dir/UCI HAR Dataset")

#read in files
features <- read.table("features.txt", header = FALSE)
activity <- read.table("activity_labels.txt", header = FALSE)
trainId <- read.table("./train/subject_train.txt", header = FALSE)
testId <- read.table("./test/subject_test.txt", header = FALSE)
trainX <- read.table("./train/X_train.txt", header = FALSE)
trainY <- read.table("./train/Y_train.txt", header = FALSE)
testX <- read.table("./test/X_test.txt", header = FALSE)
testY <- read.table("./test/Y_test.txt", header = FALSE)

#rename the columns and merge accordingly
colnames(testX) <- features[,2]
colnames(activity) <- c("activityId", "activity")
colnames(testY) <- "activityId"
colnames(testId) <- "subjectId"

temp_merge <- cbind(testId, testY, testX)

colnames(trainX) <- features[,2]
colnames(trainY) <- "activityId"
colnames(trainId) <- "subjectId"

temp_merge_train <-  cbind(trainId, trainY, trainX)

mergedData <- rbind(temp_merge,temp_merge_train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

start <- subset(mergedData, select = c("subjectId","activityId"))
meanvals <- mergedData[grepl("mean", colnames(mergedData))]
stdvals <- mergedData[grepl("std", colnames(mergedData))]
middle <- cbind(start, meanvals)
extractedData <- cbind(middle, stdvals)


# 3. Uses descriptive activity names to name the activities in the data set

extractedData <- merge(activity, extractedData)

# 4. Appropriately labels the data set with descriptive variable names
# not sure what the question is asking for, as I think most of the variable names are appropriate.
# Accordingly, the only thing I do is to remove the curly braces in the column names....Hope that works..

columnnames <- colnames(extractedData)
columnnames <- gsub("\\()", "", columnnames)
colnames(extractedData) <- columnnames

# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

cleanData <- subset(extractedData, select = c(1, 3:49))
cleanData <- aggregate(subset(cleanData, select = -c(1,2)), by = list(cleanData$activityId, cleanData$subjectId), FUN = mean)
colnames(cleanData)[1:2] <- c("activityId", "subjectId")
cleanData <- merge(activity, cleanData)

write.table(cleanData, "cleanData.txt", row.names = TRUE, sep = "\t")
write.table(extractedData, "extractedData_Q1ToQ4.txt", row.names = TRUE, sep = "\t")
