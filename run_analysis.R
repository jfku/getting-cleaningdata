############### run_analysis.R ###############

# 0. Load packages
library(tidyverse)

# 1. Fetching zip file from web and unzip datasets in specific folder
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "smartphone_data.zip")
unzip("smartphone_data.zip", exdir = "smartphone_data")

# 2.1 read train data 
x_train <- read.table("smartphone_data/UCI HAR Dataset/train/X_train.txt") 
y_train <- read.table("smartphone_data/UCI HAR Dataset/train/Y_train.txt") 
sub_train <- read.table("smartphone_data/UCI HAR Dataset/train/subject_train.txt") 

# 2.2 read test data 
x_test <- read.table("smartphone_data/UCI HAR Dataset/test/X_test.txt") 
y_test <- read.table("smartphone_data/UCI HAR Dataset/test/Y_test.txt") 
sub_test <- read.table("smartphone_data/UCI HAR Dataset/test/subject_test.txt") 

# 2.3 read features
features <- read.table("smartphone_data/UCI HAR Dataset/features.txt") 

# 2.4 read activity labels 
activity_labels <- read.table("smartphone_data/UCI HAR Dataset/activity_labels.txt") 

# 3. Assigning column names to data sets
colnames(x_train) <- features[,2]
colnames(y_train) <- c("activity_ID")
colnames(sub_train) <- c("subject_ID")

colnames(x_test) <- features[,2]
colnames(y_test) <- c("activity_ID")
colnames(sub_test) <- c("subject_ID")

colnames(activity_labels) <- c('activity_ID','activity_type')

# 4. Merge data sets to a single data set, join activity labels to the ID and then join the columns together
x_all <- rbind(x_train, x_test) 
y_all <- rbind(y_train, y_test) 
y_all <- merge(y_all, activity_labels, by="activity_ID")
sub_all <- rbind(sub_train, sub_test) 

all_all <- cbind(sub_all, y_all, x_all)

# 5. Extract column names of all_all
cnames <- colnames(all_all)

# 6. Get vector with info on which columns have activityID, subjectID, mean or std in the name
select_vector <- grepl("activity_type", cnames)|grepl("subject_ID", cnames)|grepl("mean\\(\\)", cnames)|grepl("std\\(\\)", cnames) 

# 7. Subset all_all with the vector
all_all_sub <- all_all[,select_vector]

# 8. Find average value per activity and subject for all columns
tidy <- aggregate(.~subject_ID+activity_type, all_all_sub, mean)

# 9. Make a file out of the tidy dataset
write.table(tidy, "tidy.txt")