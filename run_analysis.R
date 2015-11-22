####################################################
## run_analysis.R
## Class Project: Getting and Cleaning Data
## Mark Becker
## Requires library(dplyr)
## Writes out tidy dataset created from UCI HAR data to file: ./UCI_HAR_Tidy_Dataset.txt
## To read and preserver column names:
##   tidy_dataset <- read.table("./UCI_HAR_Tidy_Dataset.txt", check.names = FALSE)
####################################################

#read in data from UCI HAR datasets test and training
#set column names to be the descriptive feature labels, e.g. fBodyAcc-mean()-X
read_hci_dataset <- function() {
  feature_labels <- read.table("./UCI HAR Dataset/features.txt")
  test_set <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = feature_labels$V2, check.names = FALSE)
  training_set <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = feature_labels$V2, check.names = FALSE)
  hci_dataset <- rbind(test_set, training_set)
  hci_dataset$linenum <- seq(1, length(hci_dataset[[1]]))
  hci_dataset
}


createTidyDataset <- function() {
  #read data into global variable
  if(!exists("hci_dataset")) {
    print("Loading HCI dataset.")
    hci_dataset <<- read_hci_dataset()
  }
  
  #read files containing subject, activity and feature identifications and labels
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity_label"))
  activities_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("activity_id"))
  activities_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("activity_id"))
  
  #combine activities for test and training and add linenum
  activities <- rbind(activities_test, activities_train)
  activities <- merge(activities, activity_labels, by = "activity_id")
  activities$linenum <- seq(1,length(activities$activity_id))
  
  #merge activities into hci dataset
  merged_dataset <- merge(hci_dataset, activities, by = "linenum")
  
  #combine subjects for test and training and add linenum
  subjects_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("subject_id"))
  subjects_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("subject_id"))
  subjects <- rbind(subjects_test, subjects_train)
  subjects$linenum <- seq(1,length(subjects$subject_id))
  subjects$subject_label <- paste("Subject", subjects$subject_id, sep = "-")
  
  #merge subjects into hci dataset
  merged_dataset <- merge(merged_dataset, subjects, by = "linenum")
  
  #select only "mean()" and "std()" columns
  feature_labels <- read.table("./UCI HAR Dataset/features.txt")
  feature_cols <- as.vector(feature_labels$V2[grepl(".*(mean\\(|std\\()).*", feature_labels$V2)])
  select_cols <- c(c("subject_label", "activity_label"), feature_cols)
  merged_dataset <- merged_dataset[select_cols]
  
  #NOTE: REQUIRES library(dplyr)
  #find average of all columns grouped by subject and activity
  tidy_dataset <- merged_dataset %>% group_by(subject_label, activity_label) %>% summarise_each(funs(mean))
  
  #write out tidy dataset
  write.table(tidy_dataset, file = "./UCI_HAR_Tidy_Dataset.txt")
  print("Finished writing file: ./UCI_HAR_Tidy_Dataset.txt")
  tidy_dataset
  
}