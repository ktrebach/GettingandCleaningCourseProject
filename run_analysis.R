## Getting and Cleaning Course Project
## Please read the accompanying codebook.md and README.md at GitHub
## This script will:
##    1. Merge the training and the test sets to create one data set.
##    2. Extract only the measurements on the mean and standard deviation for each measurement. 
##    3. Use descriptive activity names to name the activities in the data set
##    4. Appropriately label the data set with descriptive variable names. 
##    5. From the data set in step 4, creates a second, independent tidy data set with
##          the average of each variable for each activity and each subject.

## The data are collected from the accelerometers from the Samsung Galaxy S smartphone.
## A description of the data is here:  
##    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## Final Project: submit on github run_analysis R script, a ReadMe markdown document, 
##          a Codebook markdown document, and a tidy data text file (this last goes on Coursera)


dataUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Download, unzip, read; it's pretty big so we want to check to see if it's already been downloaded
setwd("~/Downloads")
if(!file.exists("~/Downloads/UCI HAR Dataset/features.txt")) {
      download.file(dataUrl,destfile="./Dataset.zip",method="curl")
      unzip("Dataset.zip")
      timemarker<-Sys.time()
      write(timemarker,file="~/Downloads/UCI HAR Dataset/DownloadDateTime.txt")  ## record download date/time
}

## Read activity labels and features list tables


read.table("~/Downloads/UCI HAR Dataset/activity_labels.txt")->act_labels
read.table("~/Downloads/UCI HAR Dataset/features.txt")->features

## Read test tables

read.table("~/Downloads/UCI HAR Dataset/test/subject_test.txt")->subj_test ##2947 obs x 1 variable
                  ##identifies which of the 9 subjects (volunteers) for each row of data 
read.table("~/Downloads/UCI HAR Dataset/test/X_test.txt")->X_test ##2947 obs x 561 variables
read.table("~/Downloads/UCI HAR Dataset/test/y_test.txt")->y_test  ##2947 obs x 1 variable
                  ##identifies which of the 6 activities for each row of data 

## Read train tables

read.table("~/Downloads/UCI HAR Dataset/train/subject_train.txt")->subj_train ##7352 obs x 1 variable
                  ##identifies which of the 21 subjects (volunteers) for each row of data 
read.table("~/Downloads/UCI HAR Dataset/train/X_train.txt")->X_train ##7352 obs x 561 variables
read.table("~/Downloads/UCI HAR Dataset/train/y_train.txt")->y_train  ## 7352 obs x 1 variable
                  ##identifies which of the 6 activities for each row of data 

## Assign column names
colnames(X_test)<-features$V2  ##assign colnames to X_test
colnames(X_train)<-features$V2  ##assign colnames to X_train

## Add columns to identify subject and activity to each of X_test and X_train
X_test2<-cbind(subject=subj_test$V1,X_test) ## add subj_test to the X_test (identifies the subject)
X_test2<-cbind(activity=y_test$V1,X_test2) ## add y_test to the X_test (identifies which activity)

X_train2<-cbind(subject=subj_train$V1,X_train) ## add subj_train to the X_train (identifies the subject)
X_train2<-cbind(activity=y_train$V1,X_train2) ##add y_train to the X_train (identifies which activity)

## Merge the test and train data sets
bigdata<-rbind(X_train2,X_test2)

## Use dplyr to finish the tidying process
library(dplyr)

bigdata<-bigdata[, !duplicated(colnames(bigdata))] ## to remove duplicated col names

bigdata<-merge(bigdata,act_labels,by.x="activity",by.y="V1", all=TRUE) ## adds activity labels 

bigdata<-bigdata %>%
      
      select(activity,subject,V2,contains("mean()"),contains("std()")) %>% ## selects desired feature variables
      
      select(subject,activity=V2,contains("mean()"),contains("std()")) %>% ## renames activity label variable and sort columns
      
      arrange(subject,activity) ## initial tidy data set sorted by subject then activity

## Create a second tidy data set with the average of each variable for each activity and each subject.

HARMeans<-bigdata %>%
      
      group_by(subject,activity) %>%  ## Group the table by subject and activity
      
      summarise_each(funs(mean)) ## Gives a 180 x 68 table of the averages of the Means and Standard Deviation
                                 ## of each feature variable for each subject-activity combination 

## Write HARMeans to a text file in my local GIT repository.
write.table(HARMeans,
            "~/Desktop/Data Scientist JH MOOC/Getting Cleaning/GettingandCleaningCourseProject/HARMeans.txt",
            sep="\t",row.name=FALSE)

print(c("The initial tidy data set is in the global environment as 'bigdata'.", 
      "The second tidy data set is in the global environment as 'HARMeans'.",
      "HARMeans.txt has been written to the local Git repository."))
## End
