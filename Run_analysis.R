# Get the data and check for packages 
##############################################

# Download the data if necessary 
FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
FileName <- "UCI HAR Dataset.zip"

if (file.exists(FileName)){
    download.file(FileUrl, FileName)
}
# Check if the dplyr package is installed
if(!library(dplyr, logical.return = TRUE)) {
    # It didn't exist, so install the package, and then load it
    install.packages('dplyr')
}
# load dplyr 
library(dplyr)

# 1 Merge the training and test data set 
#############################################

# Read the data 
training_Subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
training_Values <- read.table("./UCI HAR Dataset/train/x_train.txt")
training_Activity <- read.table("./UCI HAR Dataset/train/y_train.txt")

test_Subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_Values <- read.table("./UCI HAR Dataset/test/x_test.txt")
test_Activity <- read.table("./UCI HAR Dataset/test/y_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table( "./UCI HAR Dataset/activity_labels.txt")
# Name the activity data set 
colnames(activities) <- c("activityId", "activityLabel")

# bind the columes of training data and test data, then bind both of them by rows 
TrainingandTest <- rbind(
    cbind(training_Subjects, training_Values, training_Activity),
    cbind(test_Subjects, test_Values, test_Activity)
)
# 2 Extract only the measurements on the mean and standard deviation for each measurement
#################################################
colNames <- grepl("subject|activity|mean|std", colnames(TrainingandTest))
#Update the data accordingly 
TrainingandTest <- TrainingandTest[, colNames]

# 3 Use descriptive activity names to name the activities in the data set
#################################################
TrainingandTest$activity <- factor(TrainingandTest$activity, 
                                 levels = activities[, 1], labels = activities[, 2])

# 4 Appropriately label the data set with descriptive variable names
#################################################

colnames(TrainingandTest) <- c(
    'subject',
    'activity',
)

# 5 Create a second, independent tidy data set with the average of each variable for each activity and each subject
###################################################

# use the group_by and summarize function
TrainingandTest_group <- TrainingandTest %>% 
    group_by(subject, activity) 
# insert a new column of data 
Tidy <- TrainingandTest_group%>% 
    summarise_each(funs(mean))
# Generate tidy data 
write.table(Tidy, "tidy_data.txt")








