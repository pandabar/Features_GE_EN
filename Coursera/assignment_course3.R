#packages
library(dplyr)

#download data
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "myfile.zip")

####STEP 1: MERGE THE DATA####

#open test files
subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
values<-read.table("UCI HAR Dataset/test/X_test.txt")
labels<-read.table("UCI HAR Dataset/test/y_test.txt")

#bind
testdata<-data.frame(cbind(subject, labels, values))

#get col labels
labs<-read.table("UCI HAR Dataset/features.txt")

#create vector for all col labels
colnames(testdata)<-c("subject", "activity", labs$V2)
View(testdata)

#label these as test
testdata$dataset<-rep("test", nrow(testdata))

#open train files
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
valuestrain<-read.table("UCI HAR Dataset/train/X_train.txt")
labelstrain<-read.table("UCI HAR Dataset/train/y_train.txt")

#bind
traindata<-data.frame(cbind(subjecttrain, labelstrain, valuestrain))
colnames(traindata)<-c("subject", "activity", labs$V2)

#label these as train
traindata$dataset<-rep("train", nrow(traindata))

#merge train and test
both<-rbind(traindata, testdata)

#### STEP 2: EXTRACT RELEVANT MEASUREMENTS ####

#get cols matching strings ("mean" and "std").

justmeanstd<-both %>% select(subject, activity, matches("mean()") | matches("std\("))

#### STEP 3: RENAME ####
#changed activity number to meaningful names
renamed<-justmeanstd %>% mutate(activity_type = recode(activity,
                                              `1` = "walking", 
                    `2` = "walking_upstairs", 
                    `3` = "walking_downstairs",
                    `4` = "sitting",
                    `5` = "standing", 
                    `6` = "laying")) %>% select(!activity) %>% relocate(activity_type, .after=subject)

#### STEP 4 WAS DONE TOGETHER WITH STEP 1 ####

#### STEP 5: GET INDEPENDENT DATA SET ####

# calculated means by subject and activity
final<- renamed %>%
  group_by(subject, activity_type) %>%
  summarise_if(is.numeric, mean, na.rm = TRUE)

#### STEP 6: SAVE NEW DATASET ####

write.table(final, "tidydata_course3.txt", row.name=FALSE)
