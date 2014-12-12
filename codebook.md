#CODEBOOK FOR GETTING AND CLEANING COURSE PROJECT

##Course Project Description

The goal is to read and process the Human Activity Recognition Using Smartphones Dataset and create a tidy dataset. From this, another tidy dataset of the average of each mean and each standard deviation variable for each activity and each subject will be created. 

###Background
The dataset is provided by Smartlab.  From Smartlab's dataset description:

"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 


The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. "  

Please refer to the following website for a full description of the dataset.  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The Course Project requirements are as follows:
You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The dataset is located here:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


###Description of Raw Dataset:  From Smartlab
For each record it is provided:


- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.

- Triaxial Angular velocity from the gyroscope. 

- A 561-feature vector with time and frequency domain variables. 

- Its activity label. 

- An identifier of the subject who carried out the experiment.



The dataset includes the following files:


- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.


The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


Notes: 

- Features are normalized and bounded within [-1,1].

- Each feature vector is a row on the text file.


For more information about this dataset contact: activityrecognition@smartlab.ws

###Preliminary Investigation of Dataset
In order to orient the user of the script, it is important to understand the raw data structure, files and contents.

The dataset is available in a zipped file. Once unzipped, the data set folder is called UCI HAR Dataset. This folder contains four text files, and two internal folders, "test" and "train".
* activity_labels.txt:  list of the 6 activities, each assigned to an integer 1 to 6 (dimensions 6x2)
* features.txt:  list of the 561 variables in the features set, each assigned to an integer 1 to 561 (dimensions 561x2).  It is noted after viewing the list of feature variables that some of the feature variable names are duplicated.  Since none of them are mean or standard deviation measures, they can safely be removed at any time.
* features_info.txt: is a markdown file with additional description of the features and is not used in the project.
* The test folder contains: 
*  X_test.txt: the test set which contains 2947 observations with 561 variables and corresponds to the six activities performed by the 9 subjects selected to be in the train subset.
*  subject_test.txt:  identifies which of the 9 subjects (volunteers) for each row of data 
*  y_test.txt:  identifies which of the 6 activities for each row of data 

* The train folder contains: 
*  X_train.txt: the train set which contains 7352 observations with 561 variables and corresponds to the six activities performed by the 21 subjects selected to be in the train subset.
*  subject_train.txt:  identifies which of the 21 subjects (volunteers) for each row of data 
*  y_train.txt:  identifies which of the 6 activities for each row of data 

The data in both inertial signals folders were used to generate the variable features and were not used for the Course Project.

###Tidy Datasets Variables and Structure
The initial tidy dataset will include both the test data and the train data and will contain (7352+2947) = 10,299 rows of data corresponding to all (30) volunteer activity results in the data set.

Further, the initial tidy data set will include the following columns (variables):
* activity  (character) -  one of six descriptive activity labels that corresponds to the integer assigned in the y_train or y_test files for each volunteer activity.
* subject  (integer) -  the identification of each volunteer for each observation (1 to 30)
* 66 feature variables (numeric) -  these variables are a subset of the 561 features described above.  This subset contains only variables that calculate the mean and standard deviation of the various data.  Variables which measure the meanFreq were excluded.

The second tidy data set will include an average of the 66 feature variables by each combination of subject and activity. The number of rows will be 180 (6 activities for each of the 30 volunteers).  The variable (number of columns) in this data set will be the same 68 variables in the initial tidy dataset (activity, subject and 66 feature variables). 


###Steps for Processing the Raw Data 

1. dplyr must be installed in the R environment
2. Run the run_analysis.R script

###What does run_analysis.R script do?
1. Download the dataset into the local directory and unzip if it hasn't already been done.
2. Read the txt files described above into R using read.table and assign table names
3. Assign column names to the X_test and X_train using the values from the respective features file
4. Add subj_test to the X_test table to identify the subject (variable name is subject) and add y_test to identify which activity (variable name is activity) for each observation in X_test. (use cbind)
5. Add subj_train to the X_train table to identify the subject and add y_train to identify which activity for each observation in X_train. (use cbind)
6.  Merge the test and train data sets using rbind.  Please note that the distinction between test subjects and train subjects will be lost upon this merge.  It is not a requirement of the Course Project to retain the distinction.
7.  Remove duplicately named variables.
8.  Add the descriptive activity labels to the dataset to replace the numeric code using merge
9. Select and arrange the following columns:  activity, subject, and the subset (66) of the 561 feature variables that contain mean() or std(). 
10. Arrange the rows by subject then activity,

The result is an object, 'bigdata', which is the initial tidy data set.  Dimensions:  10,299 x 68


From the initial tidy data set, the second tidy data set is now created:
1. Group the initial tidy data set by subject and activity.
2. Calculate the mean of each of the 66 feature variables using summarize
3. Sort by subject then activity.
4. Write the resulting second tidy dataset to a text file "HARMeans.txt" into a local git repository.

The result is an object, 'HARMeans', which is the second tidy dataset.  Dimensions: 180 x 68

END