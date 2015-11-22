#README.md
### run_analysis.R
### Coursera class: Getting and Cleaning Data
### Mark Becker

The run_analysis.R script meets the requirements for the Coursera Getting and Cleaning Data class project.  

It reads data from the UCI HAR test and training datasets provide with the project, as well as the activity and subject files and their labels.  

It creates a tidy dataset that combines the two datasets, provides descriptive variable names, and includes descriptive identifications of subjects and activities, selects only the mean and std variables, and calculating average values for all variables grouped by subject and activity.  

It then writes the tidy dataset out to a file: ./UCI_HAR_Tidy_Dataset.txt    

Requires:  
* dplyr library.

To run:  

  * source("run_analysis.R") 
  * createTidyDataset()  


To read the dataset back in (preserving column names):

* tidy_dataset <- read.table("./UCI_HAR_Tidy_Dataset.txt", check.names = FALSE) 


Example code to examine the data:

```{R}

subset(tst_tidy, select = c("subject_label", "activity_label", "fBodyAcc-mean()-X", "fBodyAcc-mean()-Y", "fBodyAcc-mean()-Z"))

subset(tst_tidy, select = c("subject_label", "activity_label", "fBodyAcc-mean()-X", "fBodyAcc-mean()-Y", "fBodyAcc-mean()-Z"), subset = (activity_label == 'WALKING'))

subset(tst_tidy, select = c("subject_label", "activity_label", "fBodyAcc-mean()-X", "fBodyAcc-mean()-Y", "fBodyAcc-mean()-Z"), subset = (subject_label == 'Subject-20'))


```

See the file Codebook.md for description of the variable names and transformations of the data.



 

