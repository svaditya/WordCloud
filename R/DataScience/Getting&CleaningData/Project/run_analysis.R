install.packages("dplyr")
library(dplyr)

#Read features in to a data frame from features.txt 
features_names<-read.table("./Samsung Data/features.txt")

#Read test data in X_test.txt in to a data frame
X_test<-read.table("./Samsung Data/test/X_test.txt",header=FALSE,sep="")
X_test<-tbl_df(X_test)
#Assigning column names to X_test
colnames(X_test)<-features_names$V2


#Read test lables in y_test.txt in to a data frame
y_test<-read.table("./Samsung Data/test/y_test.txt",header=FALSE,sep="")
#Read subject labels in subject_test in to a data frame
subject_test<-read.table("./Samsung Data/test/subject_test.txt",header=FALSE,sep="")


#Appending Activity Lables to X_test (Test Data)
X_test$activitylabels<-y_test$V1
#Sppending Subject Labels to X_test (Test Data)
X_test$subject<-subject_test$V1

#Repeating the above with train data

#Read train data in X_train.txt in to a data frame
X_train<-read.table("./Samsung Data/train/X_train.txt",header=FALSE,sep="")
X_train<-tbl_df(X_train)
#Assigning column names to X_train
colnames(X_train)<-features_names$V2


#Read test lables in y_train.txt in to a data frame
y_train<-read.table("./Samsung Data/train/y_train.txt",header=FALSE,sep="")
#Read subject labels in subject_train in to a data frame
subject_train<-read.table("./Samsung Data/train/subject_train.txt",header=FALSE,sep="")


#Appending Activity Lables to X_train (Train Data)
X_train$activitylabels<-y_train$V1
#Sppending Subject Labels to X_train (Train Data)
X_train$subject<-subject_train$V1


#Question1: Merges the training and the test sets to create one data set.

#Checking if the Column names match
identical(colnames(X_train),colnames(X_test))
#Appending the Train and Test Data
train_test<-rbind(X_test,X_train)

#Question2: Extracts only the measurements on the mean and standard deviation for each measurement.
#Column names containing mean or std
c_names<-grep("mean|std",colnames(train_test),value=TRUE)
#Add Subject and Acitivity ables
c_names<-c(c_names,"subject","activitylabels")
#Subsetting bases on required column names
train_test_meanorstd<-train_test[,c_names]

#Question3:Uses descriptive activity names to name the activities in the data set
#Read Activity Labels in activity_labels.txt in to a data frame
activitylabels<-read.table("./Samsung Data/activity_labels.txt",header=FALSE,sep="")
colnames(activitylabels)<-c("activitylabels","activitydescription")

#Merge by Activity Labels
train_test_final<-merge(train_test_meanorstd,activitylabels,by.x="activitylabels",by.y="activitylabels",all=TRUE)

#Question4: Appropriately labels the data set with descriptive variable names.
#All columns approriately named
names(train_test_final)

#Question5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
train_test_final<-tbl_df(train_test_final)
#Grouping by Activity Description and Subject
train_test_final<-group_by(train_test_final,activitydescription,subject)
#Summarizing by Activity and Subject
train_test_summary<-summarise_each(train_test_final, funs(mean))

# Writing the output to summary.txt in working directory
write.table(train_test_summary,file="./summary.txt",row.names=FALSE)
