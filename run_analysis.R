## Working firectory is UCI HAR Dataset with the subdirectory  
## and file structure as was in the original zip file.

## Load the reshape2 package to be used in STEP 5

library(reshape2)

## STEP 1: Merges the training and the test sets to create one data set

# Read data into data frames
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
X_test <- read.table("./test/X_test.txt")
y_train <- read.table("./train/y_train.txt")
y_test <- read.table("./test/y_test.txt")

# Add column names for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# Add column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# Add column names for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# Combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)


## STEP 2: Extracts only the measurements on the mean and standard
## deviation for each measurement.

# Determine which columns contain "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))

# Ensure that we also keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# Remove unnecessary columns
combined <- combined[, meanstdcols]


## STEP 3: Uses descriptive activity names to name the activities
## in the data set.
## STEP 4: Appropriately labels the data set with descriptive
## variable names. 

# convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## STEP 5: Creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

# Create the tidy data set
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

# Write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)
