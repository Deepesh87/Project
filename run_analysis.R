# read the train subject file 
# This contains the number of observations of each participant 

subject_train=read.table("subject_train.txt")
# lets give the variable a name say participant
names(subject_train)="participant"
str(subject_train)


# lets read the features data

features=read.table("features.txt")
str(features)
# this contains two variables one gives the serial number and the second variable gives the measurement taken
# let us save the measurements into a vector
# there are 561 variable names or measurements




# read the x train file

x_train=read.table("X_train.txt")
str(x_train)
nrow(x_train)
ncol(x_train)

# read the y train file
y_train=read.table("y_train.txt")
str(y_train)
nrow(y_train)
table(y_train$V1)
# this has the number of occorences of the types of activities from 1 to 6 which is explained below

activity=read.table("activity_labels.txt")
str(activity)
# So there are a total of 6 activities as seen in the activity table


# we read the test data set in a similar way as we read the train data

subject_test=read.table("subject_test.txt")
str(subject_test)
names(subject_test)="participant"

x_test=read.table("X_test.txt")
str(x_test)

y_test=read.table("y_test.txt")


# now we combine the training and the test data set using the row bind function

merged_data=rbind(training,test)
nrow(merged_data)
ncol(merged_data)
str(merged_data)
names(merged_data)


#==================================================================
# PROBLEM 1:
# Merges the training and the test sets to create one data set.
merged_data=rbind(x_train,x_test)
str(merged_data)
# this has 10299 obs and 561 variables

#==================================================================
# PROBLEM 2:
# Extracts only the measurements on the mean and standard deviation for each measurement. 


# the measurement variables are present in features table as we read above
# According to the problem statement we needto filter the variables so that we are left with only 
# the mean() and the std() [standard deviation measurements].I do it with grepl function

MeanVar=grepl("mean\\(\\)",features$V2) # this gives us the location of the variable for mean() measurements
StdVar=grepl("std\\(\\)",features$V2)  # this gives us the location of the variable for std() measurements
MeanRows=which(MeanVar==TRUE) # to fins the row number of the mean() reasurements
StdRows=which(StdVar==TRUE)   # to fins the row number of the std() reasurements
allVar=c(MeanRows,StdRows)    # gives all the variables we need to keep and delete the rest

# now we need to extract only the variables from the merged_data DF whoch have the variables as filtered above
merged_data=merged_data[,allVar]
str(merged_data)  # this keeps only the required variables as wanted by the Problem statement

#==================================================================
# PROBLEM 4:
#Appropriately labels the data set with descriptive variable names. 


#let us borrow the descriptive names of the variables from the features table
# V2 variable of features has all the descripive names. Let put them into a vector
Varnames=features$V2
# now we need only the var names with mean() and std() as we filtered in Problem2.
Varnames=Varnames[allVar]
length(Varnames)
# let us put these variable names into the merged_data 
names(merged_data)=Varnames

#==================================================================
# PROBLEM 3:
#Uses descriptive activity names to name the activities in the data set


# the activity names are present in the activity data frame
# the activity of each measuremtn is present in y_train and y_test data frames
# let us merge these into the merged_data DF

all_activity=rbind(y_train,y_test)
str(all_activity)
names(all_activity)="activity"
merged_data=cbind(merged_data,all_activity)
str(merged_data)

#==================================================================
# PROBLEM 5:
#From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject. 

# let us add the subject to the merged data set

all_subject=rbind(subject_train,subject_test)
str(all_subject)

# then merge it to the merged data frame

merged_data=cbind(all_subject,merged_data)
str(merged_data)
dim(merged_data)

library(dplyr)
library(plyr)
colnames(merged_data)
arrange(merged_data,participant,activity)

tidy_data=ddply(merged_data,.(participant,activity),function(x) colMeans(merged_data[,2:67]))
dim(tidy_data)

write.table(tidy_data,file="tidy_data.txt",row.names = FALSE)













