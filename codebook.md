codebook:
Source
Reference
source: readme.txt, features.txt to provide important background meanings.
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

Setup:
source data
unzip to...
run_analysis
tidy output

Analysis Steps:
<all documented within the run_analysis>
The only changes needed would be the working directory
load the data files.
combine the columns for subject (an id) and activity (an id)
'join' the activity id to the activity_labels.txt data to replace with activity label
combine the train and test data.
Column selection for tidy based on criteria
extraction of reduced dataset
label new dataset
perform mean across, grouping by
write out csv.

