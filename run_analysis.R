## Coursera project file 
## 2014-07-27

## open data

setwd("C:\\Users\\moshyka\\Documents\\Financial\\2014_Annual\\Coursera_data_cleaning\\Project\\UCI HAR Dataset\\Coursera_tidy_dataset_201407") 

features_data <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
x_train <- read.table("./train/X_train.txt")
x_test <- read.table("./test/X_test.txt")
y_train <- read.table("./train/Y_train.txt")
y_test <- read.table("./test/Y_test.txt")
y_merged <- rbind(y_train, y_test)

x_merged <- rbind(x_train, x_test)
subject_train <-read.table("./train/subject_train.txt")
subject_test <-read.table("./test/subject_test.txt")
subject_merged <- rbind(subject_train, subject_test)
subject_xx <- read.lines("./train/subject_train.txt")

## merge training and test sets
x_merged <- rbind(x_train, x_test)
c(nrow(x_merged), ncol(x_merged))

## label the data set using descriptive variable names
colnames(x_merged) <- features_data[,2]
data_merged <- cbind(subject_merged, x_merged) 
ncol(data_merged)


## extract means and SDs for each measurement
get.cols <- grep("mean[^Freq]", colnames(data_merged), value = TRUE)
data_means <- data_merged[, get.cols]
get.cols <- grep("std", colnames(data_merged), value = TRUE)
data_std <- data_merged[, get.cols]
mean_std_data <- cbind(patient_id = data_merged[,1], data_means, data_std)


## use descriptive activity names to name the activities in the data set
sub_act_data <- cbind(mean_std_data, activity = y_merged[,1])
sub_act_data[,"activity"] <- factor(sub_act_data[,"activity"],
                                    levels = activity_labels[,1],
                                    labels = activity_labels[,2])

## create a tidy data set with average of each variable for each activity and each subject
library(reshape)
melted_data <- melt(sub_act_data, id=c("patient_id", "activity"))
casted_data <- cast(melted_data, patient_id ~ activity ~ variable, mean)
melted_data2 <- melt(casted_data, id = c("patient_id"))
head(melted_data2)

library(MASS)
write.matrix(melted_data2, './test_data.txt', sep = "\t")

