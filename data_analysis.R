## run_analysis.R 

## Set your working directory here if needed
#setwd(<your working directory>)

print (paste0("You current working directory is: ", getwd()))

## Step 0. Optional Download project data and upload it to R.
## Uncomment this section if you need to download the dataset.
## NOTE: you will need to comment the first command in Section 1 (data_path = ".").

#data_path = "./data/uci_har_dataset"
#if(!file.exists(data_path)){
#        dir.create(data_path, recursive = TRUE)
#}

#dataset_file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#files_to_extract = c("UCI HAR Dataset/activity_labels.txt", 
#                     "UCI HAR Dataset/features.txt", 
#                     "UCI HAR Dataset/test/subject_test.txt", 
#                     "UCI HAR Dataset/train/subject_train.txt", 
#                     "UCI HAR Dataset/test/X_test.txt", 
#                     "UCI HAR Dataset/train/X_train.txt", 
#                     "UCI HAR Dataset/test/y_test.txt", 
#                     "UCI HAR Dataset/train/y_train.txt")


#temp_file <- tempfile(tmpdir = data_path)
#download.file(dataset_file_url, temp_file, mode ="wb" )
#unzip(temp_file, exdir = data_path, files = files_to_extract, junkpaths = TRUE)
#unlink(temp_file)


## Step 1. Merge the training and the test sets to create one data set.

data_path = "."
library(dplyr)
## 1.1 Create activities table
activities <- tbl_df(read.table(paste0(data_path, "/activity_labels.txt"), sep = " ", 
                                col.names = c("activity_id", "activity_name")))
print(paste0("Number of activities in experiment: ", as.character(nrow(activities))))

## 1.2 Create features table
features <- tbl_df(read.table(paste0(data_path, "/features.txt"), sep = " ", 
                              col.names = c("feature_id", "feature_name")))
print(paste0("Number of measurements: ", as.character(nrow(features))))


## 1.3 Create combined (train + test) table of sample ids and correcponding subject ids
subjects_set <- bind_rows(read.table(paste0(data_path, "/subject_train.txt")),
                        read.table(paste0(data_path, "/subject_test.txt")))
colnames(subjects_set) <-"subject_id"
subjects_set$sample_id <- 1:nrow(subjects_set)
print(paste0("Number of samples: ", as.character(nrow(subjects_set))))

## 1.4 Create combined (train + test) table of sample ids and corresponsing measurements vector
measurements_set  <- bind_rows(read.table(paste0(data_path, "/X_train.txt")),
                          read.table(paste0(data_path, "/X_test.txt")))
## Sanity check
dim(measurements_set)
print(paste0("Measurments Table dimentions: ", as.character(dim(measurements_set))))

## 1.5 Appropriately labels the data set with descriptive variable names.
names(measurements_set) <- gsub("\\(\\)", "", features$feature_name)

## 1.6 Create combined (train + test) table of sample ids and corresponsing activities ids
activities_set  <- bind_rows(read.table(paste0(data_path, "/y_train.txt")),
                               read.table(paste0(data_path, "/y_test.txt")))
colnames(activities_set) <- "activity_id"
activities_set$sample_id <- 1:nrow(activities_set)
##Sanity check
dim(activities_set)


## Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

selected_features_id <- grep("(-mean\\(\\)|-std\\(\\))", features$feature_name)
measurements_set <- measurements_set[, selected_features_id]
measurements_set$sample_id <- 1:nrow(measurements_set)
dim(measurements_set)
print(paste0("Selected measurments Table dimentions: ", as.character(dim(measurements_set))))

## Step 3. Uses descriptive activity names to name the activities in the data set
measurements_set <- merge(measurements_set, activities_set, by.x = "sample_id", by.y = "sample_id", all = FALSE)
dim(measurements_set)
print(paste0("Selected measurments/activities Table dimentions: ", as.character(dim(measurements_set))))

## Step 4. Appropriately labels the data set with descriptive variable names
## Done during Step 1.5


## Step 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
tidy_set <- merge(measurements_set, subjects_set, by.x = "sample_id", by.y = "sample_id", all = FALSE)
tidy_set <- select(tidy_set, -sample_id)
tidy_set <- merge(tidy_set, activities, by.x = "activity_id", by.y = "activity_id", all = FALSE)
tidy_set <- select(tidy_set, -activity_id)

tidy_set <- group_by(tidy_set, subject_id, activity_name)
tidy_set<- summarize_all(tidy_set, funs(mean))

## Sanity check
dim(tidy_set)
print(paste0("Tidy Table dimentions: ", as.character(dim(tidy_set))))


## Step 6. Save Tidy Table into a TXT file and Output it as View
View(tidy_set)
tidy_file_name = paste0(data_path, "/tidy_table.txt")
write.table(tidy_set, file = tidy_file_name, row.names = FALSE)
