##################################################################################
##Coursera Getting and Cleaning Data course Project
##Nawaraj Pokhrel
##01-30-2016
##This script does the following steps:
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##########################################################################################################
##Clean the workspace
rm(list=ls())
##Finding the current working directory
getwd()

###Setting the current working directory on the desired location

setwd("C:/Users/nawaraj/Desktop/coursera_cleaning/final")

##verifying the working directory 
getwd()

#download the file from the given URL and put the file into data folder
if(!file.exists("./data"))
{
  dir.create("./data")
}
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./data/comset.zip")
###unzip the file
unzip(zipfile = "./data/comset.zip",exdir = "./data")

###Unzip files are located in the folder UCI HAR dataset  so get the list of the files 
comp_path=file.path("./data","UCI HAR Dataset")
list_files=list.files(comp_path,recursive = TRUE)
list_files

##Read the data from the files and assigned the result to the specific variables.
###Read the Feature files 
feature_data_test=read.table(file.path(comp_path,"test","X_test.txt"),header = FALSE)
feature_data_train=read.table(file.path(comp_path,"train","X_train.txt"),header = FALSE)
###Read the Subject files
subject_data_test=read.table(file.path(comp_path,"test","subject_test.txt"),header = FALSE)
subject_data_train=read.table(file.path(comp_path,"train","subject_train.txt"),header = FALSE)
###Read the activity file
activity_data_test=read.table(file.path(comp_path,"test","Y_test.txt"),header = FALSE)
activity_data_train=read.table(file.path(comp_path,"train","Y_train.txt"),header = FALSE)
##Looking at the dimension of each files (row and columns of the dataset) and their structure
str(feature_data_test)
str(feature_data_train)
dim(feature_data_train)
dim(feature_data_test)
str(subject_data_train)
str(subject_data_test)
dim(subject_data_train)
dim(subject_data_test)
str(activity_data_train)
str(activity_data_test)
###Concatenate the tables by row:
subject_data=rbind(subject_data_train,subject_data_test)
activity_data=rbind(activity_data_train,activity_data_test)
feature_data=rbind(feature_data_train,feature_data_test)
head(feature_data)

######setting names to the variable
names(subject_data)=c("subject")
names(activity_data)=c("activity")
feature_data_names=read.table(file.path(comp_path,"features.txt"),head=FALSE)
names(feature_data)=feature_data_names$V2

####Merge the column to get the data frame 
combined=cbind(subject_data,activity_data)
final_data=cbind(feature_data,combined)
####Extract the mean and standard deviation for each measurement
#subset the name of the features  with mean() and std()
feature_sub_data_names=feature_data_names$V2[grep("mean\\(\\)|std\\(\\)",feature_data_names$V2)]

###Subset the data frame by selected names of the features
selected_names=c(as.character(feature_sub_data_names),"subject","activity")
final_data=subset(final_data,select=selected_names)
head(final_data$activity,30)

###Read the descriptive names of the activity_labels_text
activity_labels=read.table(file.path(comp_path,"activity_labels.txt"),header=FALSE)

###label the descriptive variable names
#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body
names(final_data)=gsub("^t","time",names(final_data))
names(final_data)<-gsub("^f", "frequency", names(final_data))
names(final_data)<-gsub("Acc", "Accelerometer", names(final_data))
names(final_data)<-gsub("Gyro", "Gyroscope", names(final_data))
names(final_data)<-gsub("Mag", "Magnitude", names(final_data))
names(final_data)<-gsub("BodyBody", "Body", names(final_data))
##Verify
names(final_data)
final_data$activity
###Creating independent tidy dataset
library(plyr)
final_data1=aggregate(.~subject+activity,final_data,mean)
dim(final_data1)
final_data1=final_data1[order(final_data1$subject,final_data1$activity),]
head(final_data1)
###Writing the data set into the txt file 
write.table(final_data1,file="tidydata.txt",row.names = FALSE)








