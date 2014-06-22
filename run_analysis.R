#
# run_analysis.R
#
# This script does the following. 
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
# the code below has sections labeled for each of the above activities,
# after an initial data load section


#### load and check the initial data ####

#
# data in "Inertial Signals" are raw data originally gathered from the phone
# and processed to produce the training and testing sets
# so only need to be concerned with the data in the train and test files
#

#
# read data
# - implicit sep="" parameter makes any sequence of one or more space or tabs
#   a field separator
# - colClasses definition causes an error if there is any non-numeric data value
#
test.data <- read.table("UCI HAR Dataset/test/X_test.txt"
                        , header=F
                        , colClasses="numeric"
                        )
test.labl <- read.table("UCI HAR Dataset/test/y_test.txt"
                        , header=F
                        , colClasses="numeric"
                        )
test.subj <- read.table("UCI HAR Dataset/test/subject_test.txt"
                         , header=F
                         , colClasses="numeric"
                        )
train.data <- read.table("UCI HAR Dataset/train/X_train.txt"
                         , header=F
                         , colClasses="numeric"
                         )
train.labl <- read.table("UCI HAR Dataset/train/y_train.txt"
                         , header=F
                         , colClasses="numeric"
                         )
train.subj <- read.table("UCI HAR Dataset/train/subject_train.txt"
                         , header=F
                         , colClasses="numeric"
                         )


#
# test for data cleanness
# -- all the below tests evaluate to TRUE
#

#
# some data file rows might have fewer values
# in which case some columns would be undefined (NA)
# here we test for that, finding no NAs
#
! any(is.na(test.data))
! any(is.na(train.data))
! any(is.na(test.labl))
! any(is.na(train.labl))
! any(is.na(train.subj))
! any(is.na(train.subj))

#
# each set of data and label files should have the same number of rows
#
nrow(test.data) == nrow(test.labl)
nrow(test.data) == nrow(test.subj)

nrow(train.data) == nrow(train.labl)
nrow(train.data) == nrow(train.subj)

# each data file should have 561 columns
ncol(test.data) == 561
ncol(train.data) == 561

# label data should be one column only, just like subject
ncol(test.labl)  == 1
ncol(train.labl) == 1
ncol(test.subj)  == 1
ncol(train.subj) == 1

# all label data should be valid
all( (test.labl[,] %in% c(1,2,3,4,5,6)) )
all( (train.labl[,] %in% c(1,2,3,4,5,6)) )

# all subject numbers must be valid
all( (test.subj[,] %in% seq(1,30)) )
all( (train.subj[,] %in% seq(1,30)) )

# and no subject can be data in both training and testing sets
length(
  intersect( unique(test.subj[,1])
           , unique(train.subj[,1])
           ) 
) == 0


#### 1. Merge the training and the test sets to create one data set. ####

# add subjects and labels to the left of each set
all.train <- cbind( train.subj, train.labl, train.data)
all.test <-  cbind(  test.subj,  test.labl,  test.data)

# add both sets together
all.data <- rbind( all.train, all.test )


#### 2. Extract only the measurements on the mean and standard deviation for each measurement. ####
#
# our interpretation here is that we want to keep any variable that is either the mean of the std
# of any other variable or measurement.
#

# read the names of the features
# after checking all rows only have one space between number and name

features <- read.table("UCI HAR Dataset/features.txt"
                       , header=F
                       , colClasses=c("numeric","character")
)

# pull the indexed for variables that have mean or std as part of their name
# with any combination of lower or uppercase letters.

mean.or.std <- grep('mean|std', features[,2], ignore.case=T)

# we noticed some variables are _angles_of other variables
# since they are angles and not means or std themselves, we want to exclude these

angle <- grep('angle', features[,2], ignore.case=T)

# now we just calculate the set difference
var.to.keep <- setdiff(mean.or.std, angle)

# finally, we keep the first column, with the label and other var.to.keep
# adjusting by one the col numbers due to the inclussion of the label as a first column
keep.data <- all.data[, c( c(1,2), var.to.keep+2) ]


#### 3. Use descriptive activity names to name the activities in the data set ####

# read the list of activities

activ <- read.table("UCI HAR Dataset/activity_labels.txt"
                       , header=F
                       , colClasses=c("numeric","character")
)

# from previous validation we know the data on keep.data is reliable
# we just need to look up the values and replace the label (second) column.
#
# at this point we have the following situation:
#
# dataframe   has columns
# ---------   -----------
# activ    :  (activ.num   activity.name)
# keep.data:  (subject     activ.num       ... rest of kept data columns)
# 
# we want to replace the second column in keep.data, activ.num
# with the activity.name as determined by the activ dataframe
#
# and this is how we do it:

keep.columns <- ncol(keep.data)

named.data <- cbind(            # we compose a new data frame with
  keep.data[,1]                 # the first column of keep.data:  (subject)
  , merge(                      # the merge of
    activ                       # activ    :  (activ.num  activity.name)
    , keep.data[,2]             # keep.data:  (activ.num) -- second column only
    , by.x=1                    #    first column from first table -- activ
    , by.y=1                    #    first column from second table -- the one we took from keep.data
    )                           # this gives us a 2-column result:  (activ.num, activity.name)
  [,2]                          # of which we only take the second column: (activity.name)
  , keep.data[,3:keep.columns]  # the original columns #3 and above
)

# and now we test the result; verifying that all the following conditions are true

ncol(named.data) == ncol(keep.data)     # they both have the same number of columns
nrow(named.data) == nrow(keep.data)     # and rows

all( named.data[,1] == keep.data[,1])   # the first column - subject - is the same

# second column of merge (activity.name) is the second column of the result
all( named.data[,2] == merge(activ, keep.data[,2], by.x=1, by.y=1)[,2])  

# and all the other columns stay the same
all( named.data[,3:keep.columns] == keep.data[,3:keep.columns])

# plus, we have activity names in the second column:
head(named.data[,2])


#### 4. Appropriately label the data set with descriptive variable names.  ####

# since var.to.keep has the vector of variables that we're keeping from the original set
# we can use this list to pull the corresponding names from the features vector.
#
# since a data.frame is just a list, all we need to do is change the names of the list
# to the variable names we kept, adding a name in front for the activity

names(named.data) <- c( "subject", "activity", features[var.to.keep, 2] )


#### 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.  ####

library(reshape2)

# reshape named.data into a dataframe with
# (subject, activity, variable, value) as columns

melt.data <- melt(named.data
     , id.vars = c("subject", "activity")
     , measure.vars = names(named.data[3:keep.columns])     
  )

# calculate the mean of value for each combination of
# (subject, activity, variable)


melt.means <- aggregate(melt.data$value
                     , by = melt.data[,1:3]
                     , FUN = mean
                     )

# the correctness of the resulting structure was
# reviewed with the following code

# get an initial description of the result
str(melt.means)
head(melt.means,100)
tail(melt.means,100)
names(melt.means)

# review how many different combinations of the first two columns were produced
table(melt.means$subject, melt.means$activity)

# finally, produce a wide-format dataframe
activ.averages <- dcast(melt.means, subject + activity ~ variable)

# and review the result
str(activ.averages)
names(activ.averages)

# while a bit longer, we prefer to adjust the name of the variables
# in columns 3 and beyond to make their name more accurate

names(activ.averages)[3:81] <- paste0( "Mean-of-" , names(activ.averages)[3:81] )

head(activ.averages)

#
# save the file in a flat text format
# with column names and row values separated by a space
#

write.table(activ.averages
            , file="subject_activity_averages.txt"
            , row.names=F
            )
