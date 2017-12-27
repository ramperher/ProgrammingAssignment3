## run_analysis.R
## Getting and Cleaning Data Course Project
## Ramon Perez Hernandez


# **********
# * TASK 1 *
# **********
# "Merge the training and the test sets to create one data set"


# Download and extract all files.

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
name <- "data.zip"
if(!file.exists("data.zip")) {
   download.file(url, destfile = name, method = "curl")
   if(!file.exists("UCI HAR Dataset")) {
      unzip(name)
   }
}

# The final data frame will be composed by:
# - Subject who performed the activity (from subject_train/test.txt).
# - Activity (from y_train/test.txt).
# - Measures (from X_train/test.txt).

# Loading train data frame.
train_df <- cbind(read.table("UCI HAR Dataset/train/subject_train.txt"), 
                 read.table("UCI HAR Dataset/train/y_train.txt"),
                 read.table("UCI HAR Dataset/train/X_train.txt"))

# Loading test data frame.
test_df <- cbind(read.table("UCI HAR Dataset/test/subject_test.txt"), 
                 read.table("UCI HAR Dataset/test/y_test.txt"),
                 read.table("UCI HAR Dataset/test/X_test.txt"))

# Merging train and test data frame.
df <- rbind(train_df, test_df)


# **********
# * TASK 2 *
# **********
# "Extract only the measurements on the mean and standard deviation for each measurement"


# Read features.txt, which have the names for measures in X_train/text.txt,
# and transform them to a character vector.
feat_names <- read.table("UCI HAR Dataset/features.txt")
feat_names <- as.character(feat_names$V2)

# Look for the position of names which contains "mean()" or "std()" and add them 2 in
# order to choose the correct columns in df (remember that first and second column in df 
# are the subject and the activity).
positions <- grep("mean\\(\\)|std\\(\\)", feat_names) + 2

# Choose "positions" columns + first and second column from df.
df <- df[,c(1,2,positions)]


# **********
# * TASK 3 *
# **********
# "Use descriptive activity names to name the activities in the data set"


# Read activity_labels.txt, which have the names for every activity, and transform 
# them to a character vector.
act_names <- read.table("UCI HAR Dataset/activity_labels.txt")
act_names <- as.character(act_names$V2)

# Transform df second column into factor, using act_names as levels.
df[,2] <- factor(df[,2])
levels(df[,2]) <- act_names


# **********
# * TASK 4 *
# **********
# "Appropriately label the data set with descriptive variable names"


# First and second column will be called "subject" and "activity", respectively.
# The rest of columns will use "feat_names" names as follows.
colnames(df) <- c("subject","activity",feat_names[positions-2])


# **********
# * TASK 5 *
# **********
# "From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject"


# Here we will need dplyr package with group_by/summarise_each functions.
library(dplyr)
tidy_df <- df %>% group_by(subject, activity) %>% summarise_each(funs(mean))

# Changing these column names to "MEAN-...".
colnames(tidy_df) <- c("subject","activity",paste("MEAN-",
                     feat_names[positions-2], sep = ""))

# Save tidy_df into "tidy_df.txt" file.
write.table(tidy_df, "tidy_df.txt", row.names=FALSE)
