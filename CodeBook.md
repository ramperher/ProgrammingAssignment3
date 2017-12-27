### Introduction

This Markdown file describes the variables, the data, and any transformations or work performed 
to clean up the original data in order to transform it into the final dataset.

Note that the file [run_analysis.R](https://github.com/ramperher/ProgrammingAssignment3/blob/master/run_analysis.R)
has already had all the steps followed in this project completely explained, but they will be 
reflected here for better understanding.

### Tasks

**1. Merge the training and the test sets to create one data set**

* Download raw data and extract all files. It also provides information about the mean of each file 
and variable from the dataset (so we will not explain that here).
* Load train/test data frames using read.table-cbind functions over all the files involved, which are:
  * Subject who performed the activity (from subject_train/test.txt).
  * Activity (from y_train/test.txt).
  * Measures (from X_train/test.txt).
* Merge train and test data frame using rbind. We will obtain a data frame with the same number of
variables as train and test data frames, while the number of observations will be the sum of the two.

**2. Extract only the measurements on the mean and standard deviation for each measurement**

* Read features.txt with read.table, which have the names for measures in X_train/text.txt, and 
transform them to a character vector.
* Look for the position of names which contains "mean()" or "std()" and add them 2 in order to choose 
the correct columns in our data frame (remember that first and second column in the data frame are the 
subject and the activity). For this purpose, we can use grep function with a regular expression.
* Update the data frame choosing the columns found before, in addition to the first and second column 
from the data frame (subject and activity). Now, our data frame has 68 variables (subject, activity, 33 
mean variables and another 33 std variables).

**3. Use descriptive activity names to name the activities in the data set**

* Read activity_labels.txt, which have the names for every activity, and transform them to a character 
vector, as we did with features.txt.
* Transform df second column (activity) into factor, using the previous character vector as levels.

**4. Appropriately label the data set with descriptive variable names**

* With colnames function, we will put names to all variables in the dataset.
  * First and second column will be called "subject" and "activity", respectively.
  * The rest of columns will use the names obtained in the task 2.

**5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject**

* Here we will need dplyr package with group_by/summarise_each functions.
  * Firstly, group by subject and activity.
  * After it, use summarise_each to compute the mean of the rest of variables.
* For better understanding, we will rename the measure columns use the prefix "MEAN-".
* Save the tidy data frame into a file called "tidy_df.txt" with write.table function.

### Result

The result is the tidy data frame called [tidy_df.txt](https://github.com/ramperher/ProgrammingAssignment3/blob/master/tidy_df.txt),
which presents the following structure:

* `subject` - (integer) subject who performed the activity for each window sample. Its 
range is from 1 to 30.
* `activity` - (factor) activity performed by the subject. The possible values are WALKING, 
WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING and LAYING.
* `MEAN-<variable>` - (numeric) mean of <variable> for every pair of subject-activity. The
variables involved are all the mean and std variables from the original dataset. Its meaning can 
be found in the documentation of the original dataset.
