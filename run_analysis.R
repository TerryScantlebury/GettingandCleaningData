runanalysis <- function() {
		# load libaries needed for the analysis
		
		library(plyr)
		library(dplyr)
		library(reshape)
		library(reshape2)
		
		
		#read the activity labels into a dataframe
		activity.labels <- read.table("./activity_labels.txt", header = FALSE, sep = " ")
		
		#read the feature variable (names) into a dataframe
		features <- read.table("./features.txt", header = FALSE, sep = " ", stringsAsFactors = FALSE)
		
		# read the subjects for the train data set into a dataframe
		subject.train <- read.table("./train/subject_train.txt", header = FALSE, sep = " ")
		
		# read the activities for the train data into a dataframe
		activity.train <- read.table("./train/y_train.txt", header = FALSE, sep = " ")
		
		#read the train data into a dataframe
		data.train <- read.table("./train/X_train.txt" , header = FALSE, sep = "", stringsAsFactors = FALSE)
		
		# relabel the subject dataframe column name
		names(subject.train) <- "Subject"
		
		# relabel the activity dataframe column name
		names(activity.train) <- "Activity"
		
		# read the subjects for the test data set into a dataframe
		subject.test <- read.table("./test/subject_test.txt", header = FALSE, sep = " ")
		
		# read the activities for the test data into a dataframe
		activity.test <- read.table("./test/y_test.txt", header = FALSE, sep = " ")
		
		#read the test data into a dataframe
		data.test <- read.table("./test/X_test.txt" , header = FALSE, sep = "", stringsAsFactors = FALSE)                           
		
		# relabel the subject dataframe column name
		names(subject.test) <- "Subject"
		
		# relabel the activity dataframe column name
		names(activity.test) <- "Activity"
		
		#Combine all the data frames
		#merge the subject, activity and train data into one dataframe
		data.train <- cbind(subject.train,activity.train,data.train)
		
		#merge the subject, activity and test data into one dataframe
		data.test <- cbind(subject.test,activity.test,data.test)
		
		#merge the test and train data
		data.all  <- rbind(data.train,data.test)
		
		# Use descriptive activity names to name the activities in the data set
		# because each activityID "x" is the same as the row value in the activity labels dataframe
		# I simply lookup the corresponding activity label (by row value) and return the character string
		data.all$Activity <- sapply(data.all$Activity, function(x){as.character(activity.labels$V2)[x]})
		
		# extract mean and std values. I am keeping any feature with mean or std not just the mean() and std() ones,
		# as subsequent analysis can always drop unwanted features, but can't add back any features I choose to drop now
		# p.s. an interactive examination of the features did find duplicate values for bandEnergy, however 
		# as these do not relate to mean or std, and will be dropped anyway, the issue was ignored.
		
		# extract the index position of each feature that has mean or std in the column name
		index.names <- grep("mean|std", features$V2, ignore.case = TRUE)
		# but Subject and Activity are in postion 1:2 in the data.all dataframe
		index.names <- c(1:2, index.names + 2)
		
		# select the subject, activity and features with mean and std in the name
		data.ms <- select(data.all,index.names)
		
		# extract the lables of each feature that has mean or std in the column name
		ms.names <- grep("mean|std", features$V2, value = TRUE, ignore.case = TRUE)
		# but Subject and Activity are in postion 1:2 in the data.all dataframe
		ms.names <- c("Subject","Activity", ms.names)
		
		# Label the data set with descriptive variable names.
		names(data.ms) <- ms.names
		
		# make a tidy data set with the average of each variable for each activity and each subject
		# I am using the long form for the tidy data where the measurments in the feature set are treated as variables
		# This data is tidy for the following reasons
		# 1. Each variable forms a colum. In this long form the features are treated an elements is a features set
		# 2. Each observation forms a row. In this long form the individual features are treated as unique observations
		# 3. Each type of observational unit forms a table. Note that the mean values are all based on a set of values 
		#    scaled between [-1,1] and are therefore dimensionless. 
		#    As the underlying units (time, frequency, angles) are divided out in the ratio.
		#    These dimemsionless values can therefore all appear in the same column.
		# 
		data.tidy <- melt(data.ms, id.vars = c("Subject","Activity"))
		data.tidy.ms <- ddply(data.tidy,c("Subject","Activity","variable"),summarize, mean.value = mean(value))
		write.table(data.tidy.ms,"./tidydata.txt", row.name = FALSE)
}