##codebook:
###Source
The source data has come from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
This data set has been downloaded and unzipped into the working directory for run_analysis.R <the setwd() first line can be changed to reflect alternate working directories>
The files are visible as a subdirectory structure in folder "UCI HAR Dataset/....."
Within the toplevel source folder are 4 .txt files and the user should familiarise themselves with the readme.txt and features_info.txt for detailed explanations of the data, its makeup in the source folders, and the observation details. Features.txt and activity_labels.txt provide a list of fieldnames, and a description of activitylabels. 
###Output
After run_analysis.R has been executed
The columns output in tidy are:
Subject
Activity
66 variables containing the mean of observation data for each subject / activity.
The 66 variables are a renamed subset of the original data 561
The subset was chosen for those observations that provided mean and standard deviation data only. 
The exact filter is based on selecting those where the observation title contained
a) "mean" (but not "meanfreq")
b) "std"
Note: a) also excluded "Mean", so variables related to angle were also excluded.
The variable names contained certain special characters, typically '-' and '()' and the tidy-set of data has stripped out all these characters, truncating the names. In addition all labels have been made lower_case <comment: I personally found that to make the labels decidedly less readable, however that was the explicit recommendation in the lecture notes>

###Setup and execution:
source data:
unzip the source data to the local working environment folder
run_analysis: 
Load the run_analysis.R into R Studio. Check that the first line (setwd("xxxxx")) reflects the current environment of the machine on which this has been deployed. Execute the script in R Studio either line by line (ctrl+Enter on each line) or by selecting the whole script to execute.
The resultant will be a .csv file named "meantidy.csv" output to the same working directory

###Analysis Steps:
<all documented within the run_analysis>
Objective:
Create a data set which contains the mean value, by Subject and Activity, for each observation related to 'mean' and 'std'in the original dataset.

The only changes needed to the run_analysis.R script would be the working directory setwd() statement
The script performs the following:
load the data files. There are two sets of data, labelled 'train' and 'test', containing equivalent information. The main data files, containing the 561 observation columns are the 'X_' versions of 'train' and 'test'. In addition, the 'Y_'files contain the activityid for each observation row, and the 'subject_' file contains the subjectid for each observation (both of which are not present in the 'X_' files)
combine the columns for subject (an id) and activity (an id) into the main dataset for each train/ test group
'join' the activity id to the activity_labels.txt data to replace with activity label
combine the train and test data, by row binding, into a single, master dataset of train + test, containing the subject and the activity label.
Determine the Column selection for tidy based on the following criteria:
The tidy set is comprisd of those observation fields that are related to a 'mean' or 'standard deviation'.
The precise definition used is as follows:
   labels[which(labels %like% "mean" & !(labels %like% "meanFreq"))]
   labels[which(labels %like% "std")]
selecting those observations that contain "std" or 'exactly' "mean" (excluding any with "Mean")

These criteria are then used to extract a reduced dataset containg subject, activity and the selected observation columns

label this new dataset, removing "-" and "()" from the labels and converting all to lower case (the lecture notes recommend ALL lowercase for the column labels, however in this case it may make the columns harder to read and match up with original source fields)

The final step is to calculate the mean() across the new dataset, grouping by subject and activity, giving a single mean value per observation for each subject/activity combination.
This is written out as "meantidy.csv".

