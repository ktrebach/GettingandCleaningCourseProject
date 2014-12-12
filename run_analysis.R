## This script will:
##    1. Merge the training and the test sets to create one data set.
##    2. Extract only the measurements on the mean and standard deviation for each measurement. 
##    3. Use descriptive activity names to name the activities in the data set
##    4. Appropriately label the data set with descriptive variable names. 
##    5. From the data set in step 4, creates a second, independent tidy data set with
##          the average of each variable for each activity and each subject.

##The data are collected from the accelerometers from the Samsung Galaxy S smartphone.
##A description of the data is here:  
##    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

##Final Project: submit on github run_analysis R script, a ReadMe markdown document, 
##          a Codebook markdown document, and a tidy data text file (this last goes on Coursera)

##The standard interpretation is that the starting place is the UCI folder is inside the working directory.
dataUrl<-https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##download, unzip, read; it's pretty big so we want to check to see if it's already been downloaded

##
##
setwd("/Users/seantrebach/Downloads/UCI HAR Dataset") ###need
read.table("activity_labels.txt")->act_labels ###need
## "features_info.txt" is a md file Dont need
read.table("features.txt")->features  ###need




setwd("/Users/seantrebach/Downloads/UCI HAR Dataset/test") ###need
read.table("subject_test.txt")->subj_test ##2947 obs x 1 variable-->
                  ##identifies which of the 9 subjects (volunteers) for each row of data 
read.table("X_test.txt")->X_test ##2947 obs x 561 variables
read.table("y_test.txt")->y_test  ##2947 obs x 1 variable-->
                  ##identifies which of the 6 activities for each row of data 

setwd("/Users/seantrebach/Downloads/UCI HAR Dataset/train")  ###need
read.table("subject_train.txt")->subj_train ##7352 obs x 1 variable-->
                  ##identifies which of the 21 subjects (volunteers) for each row of data 
read.table("X_train.txt")->X_train ##7352 obs x 561 variables
read.table("y_train.txt")->y_train  ## 7352 obs x 1 variable-->
                  ##identifies which of the 6 activities for each row of data 



##table(subj_text$V1) 

##  2   4   9  10  12  13  18  20  24 
##302 317 288 294 320 327 364 354 381 

##table(y_test$V1)

##  1   2   3   4   5   6 
##496 471 420 491 532 537 


##setwd("/Users/seantrebach/Downloads/UCI HAR Dataset/test/Inertial Signals")  ##not sure i need 
## to read these tables - are they idividuals that are used to calc the xy??
##read.table("body_acc_x_test.txt")->body_acc_x_test ##2947 obs x 128 variables; same for y and z
##read.table("body_gyro_x_test.txt")->body_gyro_x_test ##2947 obs x 128 variables; same for y and z
##read.table("total_acc_x_test.txt")->total_acc_x_test ##2947 obs x 128 variables; same for y and z


colnames(X_test)<-features$V2  ##assign colnames to X_test
colnames(X_train)<-features$V2  ##assign colnames to X_train

X_test2<-cbind(subject=subj_test$V1,X_test) ## add subj_test to the X_test (identifies the subject)
X_test2<-cbind(activity=y_test$V1,X_test2) ##add y_test to the X_test (identifies which activity)

##do we need to retain the test identification??  NOT A REQUIREMENT - but discuss in code book!
##filename<-rep("test",times=nrow(X_test2))  ##create a character vector to label test
##X_test2<-cbind(X_test2,filename) ## bind the label test to X_test

X_train2<-cbind(subject=subj_train$V1,X_train) ## add subj_train to the X_train (identifies the subject)
X_train2<-cbind(activity=y_train$V1,X_train2) ##add y_train to the X_train (identifies which activity)

##do we need to retain the train identification?? NOT A REQUIREMENT  - but discuss in code book
##filename<-rep("train",times=nrow(X_train2))  ##create a character vector to label train
##X_train2<-cbind(X_train2,filename) ## bind the label train to X_train

bigdata<-rbind(X_train2,X_test2) ##merge the two data sets



library(dplyr)
## to "select" only columns with mean and std  

bigdata2<-bigdata[, !duplicated(colnames(bigdata))] ## to remove duplicated col names
##bigdata2<-bigdata[!duplicated(lapply(bigdata,c))] ## to rename duplicated col names so they are all unique
##          this seems to drop some columns though!! tGravityAccMag is missing

##bigdataX<-select(bigdata2,activity,subject,filename,contains("mean"),contains("std"))
bigdata3<-select(bigdata2,activity,subject,contains("mean()"),
                 contains("std()"))
##I removed the meanFreq() variables.  EXPLAIN WHY in CodeBook

## to add activity labels 
merge(bigdata3,act_labels,by.x="activity",by.y="V1", all=TRUE)->bigdata4 
bigdata5<-select(bigdata4,subject,activity=V2,contains("mean()"),contains("std()"))

##bigdata5 is first tidy dataframe (step 4)

##step 5. From the data set above, creates a second, independent tidy data set
##          with the average of each variable for each activity and each subject.
actsubj<-group_by(bigdata5,subject,activity)
meanby_actsubj<-summarise_each(actsubj,funs(mean))

tidyF<-arrange(meanby_actsubj,subject,activity) ## 2nd tidy dataframe to be uploaded to coursera

##write tidyF to a text file is i think the last step.



##  library(reshape2) ## if using join or melt

##manual calc to get means of all variables for activity=1,subject=1
##filter(bigdata5,activity==1,subject==1)->a1s1
##meansofa1s1<-colMeans(a1s1[,4:69])