# GettingandCleaningData
GettingandCleaningData assignment

This readme explains how the run_analysis script was developed

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names.
    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Data source: 
All of the original data for the project can be found at :-
As referenced as http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Source:

Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)

1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy.

2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain

activityrecognition '@' smartlab.ws

# Original Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Attribute Information:

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

# How the tidy data was generated

##read the activity labels into a dataframe
activity.labels <- read.table("./activity_labels.txt", header = FALSE, sep = " ")

activity.labels
  V1                 V2
1  1            WALKING
2  2   WALKING_UPSTAIRS
3  3 WALKING_DOWNSTAIRS
4  4            SITTING
5  5           STANDING
6  6             LAYING

##read the feature variable (names) into a dataframe
features <- read.table("./features.txt", header = FALSE, sep = " ", stringsAsFactors = FALSE)

head(features)
V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
4  4  tBodyAcc-std()-X
5  5  tBodyAcc-std()-Y
6  6  tBodyAcc-std()-Z
str(features)
 note there are 561 rows in the features data frame

 read the subjects for the train data set into a dataframe
subject.train <- read.table("./train/subject_train.txt", header = FALSE, sep = " ")

str(subject.train)
'data.frame':	7352 obs. of  1 variable:
  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
 these values range from 1 to 30 and correspond to the 30 subjects used in the experiement

 read the activities for the train data into a dataframe
activity.train <- read.table("./train/y_train.txt", header = FALSE, sep = " ")
str(activity.train)
'data.frame':	7352 obs. of  1 variable:
  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
 these values range from 1 to 6 and correspond to the 6 activity.labels

read the train data into a dataframe
data.train <- read.table("./train/X_train.txt" , header = FALSE, sep = "", stringsAsFactors = FALSE)

 relabel the subject dataframe column name
names(subject.train) <- "Subject"

 relabel the activity dataframe column name
names(activity.train) <- "Activity"


 get the corresponding test data from the test subdirectory

 read the subjects for the test data set into a dataframe
subject.test <- read.table("./test/subject_test.txt", header = FALSE, sep = " ")

 read the activities for the test data into a dataframe
activity.test <- read.table("./test/y_test.txt", header = FALSE, sep = " ")

read the test data into a dataframe
data.test <- read.table("./test/X_test.txt" , header = FALSE, sep = "", stringsAsFactors = FALSE)                           

 relabel the subject dataframe column name
names(subject.test) <- "Subject"

 relabel the activity dataframe column name
names(activity.test) <- "Activity"

Combine all the data frames
merge the subject, activity and train data into one dataframe
data.train <- cbind(subject.train,activity.train,data.train)

merge the subject, activity and test data into one dataframe
data.test <- cbind(subject.test,activity.test,data.test)

merge the test and train data
data.all  <- rbind(data.train,data.test)

 Use descriptive activity names to name the activities in the data set
 because each activityID "x" is the same as the row value in the activity labels dataframe
 I simply lookup the corresponding activity label (by row value) and return the character string
data.all$Activity <- sapply(data.all$Activity, function(x){as.character(activity.labels$V2)[x]})

 extract mean and std values. I am keeping any feature with mean or std not just the mean() and std() ones,
 as subsequent analysis can always drop unwanted features, but can't add back any features I choose to drop now
 p.s. an interactive examination of the features did find duplicate values for bandEnergy, however 
 as these do not relate to mean or std, and will be dropped anyway, the issue was ignored.

 extract the index position of each feature that has mean or std in the column name
index.names <- grep("mean|std", features$V2, ignore.case = TRUE)
 but Subject and Activity are in postion 1:2 in the data.all dataframe
index.names <- c(1:2, index.names + 2)

 select the subject, activity and features with mean and std in the name
data.ms <- select(data.all,index.names)

 extract the lables of each feature that has mean or std in the column name
ms.names <- grep("mean|std", features$V2, value = TRUE, ignore.case = TRUE)
 but Subject and Activity are in postion 1:2 in the data.all dataframe
ms.names <- c("Subject","Activity", ms.names)

 Label the data set with descriptive variable names.
names(data.ms) <- ms.names

 make a tidy data set with the average of each variable for each activity and each subject
 I am using the long form for the tidy data where the measurments in the feature set are treated as variables
 This data is tidy for the following reasons
 1. Each variable forms a colum. In this long form the features are treated an elements is a features set
 2. Each observation forms a row. In this long form the individual features are treated as unique observations
 3. Each type of observational unit forms a table. Note that the mean values are all based on a set of values 
    scaled between [-1,1] and are therefore dimensionless. 
    As the underlying units (time, frequency, angles) are divided out in the ratio.
    These dimemsionless values can therefore all appear in the same column.
 
data.tidy <- melt(data.ms, id.vars = c("Subject","Activity"))
data.tidy.ms <- ddply(data.tidy,c("Subject","Activity","variable"),summarize, mean.value = mean(value))
write.table(data.tidy.ms,"./data.tidy.txt", row.name = FALSE)
