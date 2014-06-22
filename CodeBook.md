Summary of Human Activity Recognition data <br> collected with a smartphone<br>*CodeBook*
====

Introduction
------------
This work summarizes the data collected and processed in [1], as part of the course [Getting and Cleaning Data](https://www.coursera.org/course/getdata)[2].

The objective of this Course Project is to summarize the data into a *tidy* data set. Tidy data is defined such that
 1. each variable is in one column,
  * and variables have a human-readable name
 1. each observation is in a different row  
 1. there is one table for each kind of observed item
  * each table is stored in a different file
 1. if there is more than one table, there should be columns in the tables allowing to link them together.

Data from the original experiment
----
Data was collected from individuals wearing a smartphone.  The smartphone collected 3-axial linear acceleration and 3-axial angular velocity measurements   using its embedded accelerometer and gyroscope.

The measurements were pre-processed and filtered resulting in a set of 561 variables, activity labels and an identifier of the subject in the experiment.

Detailed descriptions of the variables produced in the original experiment can be found in [1].

Variables in this data set
----
The variables are stored in a single file called "subject_activity_averages.txt".  These correspond to variables captured in the original experiment, averaged by subject and the type of physical activity at the time the measurement was made.

The **first two variables** are

variable name|content
----|----
**subject**|a number identifying the person participating in the experiment
**activity**|the type of physical activity they were doing at the time of the  measurement

<br>
The **rest of the variables** (from #3 to #81) are named using the following conventions.

name part|interpretation
----|----
Mean-of|This prefix is present for all the variables. It indicates that the variable was calculated as the mean of one of the original variables, grouped by subject and activity
tBodyAcc<br>tGravityAcc<br>tBodyAccJerk<br>tBodyGyro<br>tBodyGyroJerk<br>tBodyAccMag<br>tGravityAccMag<br>tBodyAccJerkMag<br>tBodyGyroMag<br>tBodyGyroJerkMag<br>fBodyAcc<br>fBodyAccJerk<br>fBodyGyro<br>fBodyAccMag<br>fBodyBodyAccJerkMag<br>fBodyBodyGyroMag<br>fBodyBodyGyroJerkMag|basic feature extracted from the measurements, after pre-processing and filtering
mean()<br>std()<br>meanFreq()|indicates the aggregation made on the original measurements
X<br>Y<br>Z|indicates the direction of the original signal measurement

Data Transformations made
----
Before doing any data transformation several tests were made to ensure that the original data was clean without any missing values and that the tables were coherent in number of rows and columns.

### Merging or training and test data sets
The original data was split into training and test sets.  They were brought together as part of a single data set, after checking that no subject had observations in both sets.

A single data set was created with subject, activity and measurement variables

### Extraction of mean and standard deviation measurements
As requested for the Course Project, we extracted from the single set created above only the measurement variables that had the terms **"mean"** or **"std"** as part of their name.

We did however excluded variables with **"Angle"** as part of their name.  We took this to be an indication that the variable was measuring an angle and was not the immediate result of a mean or standard deviation calculation.

**Subject** and **Activity** were kept as identifiers of the items of observation for the rows
 
### Used descriptive activity names to name the activities in the data set
The variable Activity was encoded with numerical values.

We used the *activity_labels.txt* file to convert the numeric codes into descriptive strings naming the corresponding activity, using the merge function.

Finally, we replaced the numeric activity column with a column containing the newly calculated activity names. For this we used the cbind function to assemble a new data frame from subsets of the original one and a subset with the activity names from the merge.

### Appropriately label the data set with descriptive variable names
We took the contents of the *features.txt* file and used it as a list of names for the original variables.

Then we simply used the list of indices that we had previously calculated for the variable columns that we wanted to keep, to extract the sub-list of names for the kept variables.

Finally, we simply assigned this sublist of variable names to the names of the data set with the reduced set of variables, starting at column 3 after giving the first two columns the names of "subject" and "activity".

### Create a second, independent tidy data set with the average of each variable for each activity and each subject

This was done by
 1. transforming the data set into a "tall" data set formed by subject, activity, variable_name and variable_value columns, using the **melt** function.
 2. using the **aggregate** function to calculate the average of each variable for each subject/activity combination group
 3. using the **dcast** function to put the data back together into a wide format with each variable in a separate column.

This produced a single data frame that complied with the definition of a *tidy* data set given above, after it was stored in a single text file, with a first header line and all header and data values in the same row separated by spaces.

Files in this project
----
This includes the produced tidy data set, the R code used to produce it, CookBook and README files and the files used from the original project.

name|contents
----|----
**top level**:|
CodeBook.html|html version produced for this file
CodeBook.md|this file
README.html|html version of the README.md file
README.md|overall introduction to the project
run_analysis.R|R code used to produce the resulting tidy data set
subject_activity_averages.txt|tidy data set produced in this project
UCI HAR Dataset/|directory with a copy of the files used in this project, taken from [3]
**under UCI HAR Dataset/**|
activity_labels.txt|names for the numeric encoding of the physical activities
features_info.txt|description of features, how they were captured and processed and name parts for the variables
features.txt|numbered list of variables names
README.txt|original project README FILE
**under UCI HAR Dataset/train**|
subject_train.txt|subject numbers for the training set
X_train.txt|variable values for the original training data set
y_train.txt|variable labels for the training set
**under UCI HAR Dataset/test**|
subject_test.txt|subject numbers for the test set
X_test.txt|variable values for the original test data set
test/y_test.txt|variable labels for the test set


License
----
Use of this data set in publications must be acknowledged by referencing the following publication [1] 

This data set is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

References
----
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.  url: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. Read on 2014-06-21.

[2] Leek, Peng, Caflo; *Getting and Cleaning Data*; Johns Hopkins Bloomberg School of Public Health, [Coursera](https://www.coursera.org/); url: https://www.coursera.org/course/getdata; read on 2014-06-22.

[3] Data used for this project. URL=https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
