#This script, run_analysis.R does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Startpoint
#The data is assumed to be downloaded from
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# and unzipped into the Exercise folder, with the working directory set to this. 
#Data will be looked for in the relative paths established in the zip file.
setwd("~/Documents/coursera/Data Cleaning/Exercise")
library(data.table) #just in case
#relative path from setwd for the train dataset
trainpath = "UCI HAR Dataset/train/"
#relative path from setwd for the test dataset
testpath = "UCI HAR Dataset/test/"

#build up specific path/ names for the files to load. 
#  Could use listfiles BUT not all files present in the folder are to be used.
trainsrc = paste0(trainpath,"x_train.txt")
trainact = paste0(trainpath,"y_train.txt")
trainsub = paste0(trainpath,"subject_train.txt")
testsrc = paste0(testpath,"x_test.txt")
testact = paste0(testpath,"y_test.txt")
testsub = paste0(testpath,"subject_test.txt")

#Load the respective files into individual tables
trainT = read.table(trainsrc)
testT = read.table(testsrc)
trainA = read.table(trainact)
testA = read.table(testact)
trainS = read.table(trainsub)
testS = read.table(testsub)

#Extend the train and test datasets to include the activity and subject data: cbind to add them as columns
fullTrain = cbind(cbind(trainT,trainA),trainS)
fullTest = cbind(cbind(testT,testA),testS)
#Now rbind the two into one complete table
combined = rbind(fullTrain, fullTest)

#clean up these as no longer needed, reduce memory
#using rm() or remove() removes them completely
rm(testA, testT, testS, trainT, trainA,trainS, fullTrain,fullTest)
# 

# We need 'sensible' labels, so start with the raw labels from features.txt
# These are for the observation columns
labels = read.table("UCI HAR Dataset/features.txt")
#auto loaded as factors, so convert to characters for manipulation
labels = as.character(labels$V2)
#strip out 'illegal' chars from labels
# lecture notes recommend ALL lowercase, no underscores etc
labels4 = gsub("-","", labels)
labelsNew = gsub("()","",labels4, fixed=TRUE)
# do a subset on these to reduce the data volumes
#perform this BEFORE lowercasing as otherwise some additional, unwanted, observation columns are included by lowercase the M of Mean
# use the following two, in a combined statement
  # labels[which(labels %like% "mean" & !(labels %like% "meanFreq"))]
  # labels[which(labels %like% "std")]
selectedCols = c(which(labelsNew %like% "mean" & !(labelsNew %like% "meanFreq")),which(labelsNew %like% "std"))
labelsNew = tolower(labelsNew)

#update the labels, with the modified observation labels AND labels for the joined columns activity and subject
combined = setnames(combined,c(labelsNew,"activity", "subject"))

#Activity is provided as an id only, so we want to load the labels, and perform a lookup of the id to the label value
activities = read.table("UCI HAR Dataset/activity_labels.txt")
newact = activities[combined[,562],2]
combined$Activity = newact #rather than keep the activity id and add a label column, we simply replace it

#now create a new subset based on the subject, activity and selected observation columns.
# not the column reorganisation
newset = combined[c(563:562,selectedCols)]
#remove the intermediate data
rm(combined)

####
#This set now needs to have the mean of each observation, by subject and activity
####
DTnewset = data.table(newset)
#now perform a mean, with groupby, across all the observation columns
tidy1 = DTnewset[,lapply(.SD,mean,na.rm=TRUE), by = list(subject,activity)]
#head(try1)
write.csv(tidy1,"meantidy.csv", row.names = FALSE)

