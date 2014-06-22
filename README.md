Summary of Human Activity Recognition data <br> collected with a smartphone
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

R code
----
The tidy data set delivered with this project and stored in the *subject_activity_averages.txt* file was processed with the R code in a single file called *run_analysis.R*.

While the overall processing of the original project data is described in the *CodeBook.md* file, as part of the requirements for this project, and the R Code in *run_analysis.R* is thoroughly commented, here are some general indications of how the R Code works.

### Data Reading
First of all, the initial data files (all described in *CodeBook.md*) were read using the *read.table* function.  This made it easier to read space-separated values and also to indicate an initial validation that all values read were numeric.

### Data Validation
Since we were never told that the input data was clean, we wrote several conditions to test for having read clean data.  These were all logical expressions that if successful would evaluate to TRUE.  All tested validation conditions were met by the input data.

### Data Processing
 * Combination of data into a single data set was made using *cbind* and *rbind* functions.
 * Feature extraction was made matching the variable names with searched-for patterns in then name, using the *grep* function.  The extraction was made by calculating a vector of the indices for the variables to be extracted.  This vector later became handy to obtain the names for the extracted variables.
 * The conversion of the activity variable from numeric to nominal was made using the data stored in the *activity_labels.txt* file.  Since this file has exactly one row for each numeric-nominal pair, the *merge* operator served as a handy way to implement a look-up function. The final data set was calculated with a combination of subsetting and column binding as commented in detail in the code.
 * Variable naming was easily made using the vector of indices for the extracted variables to extract the corresponding subset from the list of all variable names.

### Final Calculations
The summarized data set required from the project was finally calculated via
 1. transforming the data set into a "tall" data set formed by subject, activity, variable_name and variable_value columns, using the **melt** function.
 1. using the **aggregate** function to calculate the average of each variable for each subject/activity combination group
 1. using the **dcast** function to put the data back together into a wide format with each variable in a separate column.
 
### Data Storage
A single data frame complying with the definition of a *tidy* data set was stored in a single *subject_activity_averages.txt* text file with
 * a header line to make data interpretation easier
 * each row written in a single line
 * all header and data values separated by spaces

Additional information
----
Can be found in the *CodeBook.md* file
 * Description of data from the original experiment
 * Description of variables in the *subject_activity_averages.txt* data set
 * More details on the data transformations made
 * List of files in this project
 
or in the code and comments in the *run_analysis.R* file


License
----
Use of the original data set in publications must be acknowledged by referencing the following publication [1] 

This data set is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


References
----
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.  URL: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. Read on 2014-06-21.

[2] Leek, Peng, Caflo; *Getting and Cleaning Data*; Johns Hopkins Bloomberg School of Public Health, [Coursera](https://www.coursera.org/); URL: https://www.coursera.org/course/getdata; read on 2014-06-22.

[3] Data used for this project. URL=https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
