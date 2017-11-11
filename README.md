# DataCleaning Course Project Description

The goal of this project is to create a tidy data set based on the original data set available here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Experimental design:
The experiments have been carried out with a group of 30 volunteers. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

## Raw data used:
* 'activity_labels.txt': Links the class labels with their activity name.
* 'features-info.txt': Contains the names of the time and frequency domain variables presented in a 561-feature vector.

The following files were available for both train and test data. Their descriptions are equivalent. 
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/X_train.txt': Training set. Contains a 561-feature vector with time and frequency domain variables. Acceleration variables are is standard gravity units 'g', angular velocity variables are in radians/second units. Features are normalized and bounded within [-1,1].
* 'train/y_train.txt': Training labels. Links each window sample with the activity for that window sample.

## The project goal:
To produce a tidy data set ("the Tidy Table") that would contain averages of all mean() and std() type variables for each activity and each subject.

## Steps to perform:
Run run_analysis.R script in the directory that contains the Samsung data raw files. You can modify the script by uncommenting "Step 0" to download raw data from the Internet source if needed. All the steps performed in the script are well documented using Comments.

The script will generate R View object containing the Tidy Table data. It will also save content of the Tidy Table into a text file called "tidy_table.txt". The output TXT file will be created in the raw files directory.





