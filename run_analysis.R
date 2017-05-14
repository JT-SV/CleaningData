# Cleaning Data course project

# Load useful modules
# For arrange
library(dplyr)
# For melt, dcast
library(reshape2)

# Working directory
setwd("~/ds/CleaningData/CourseProject")
D<-"UCI_HAR_Dataset"
# General information
# Load activity labels (the meaning of Y values)
activities<-read.table(paste(D,"activity_labels.txt",sep="/"))
# Load headings for the columns of X
headX<-read.table(paste(D,"features.txt",sep="/"),stringsAsFactors=FALSE)
# Load training individuals' ids

# Load X and Y training data
trainX<-read.table(paste(D,"train/X_train.txt",sep="/"),header=FALSE)
trainY<-read.table(paste(D,"train/y_train.txt",sep="/"),header=FALSE)
trainSubject<-read.table(paste(D,"train/subject_train.txt",sep="/"),header=FALSE)
# Load X and Y test data
testX<-read.table(paste(D,"test/X_test.txt",sep="/"),header=FALSE)
testY<-read.table(paste(D,"test/y_test.txt",sep="/"),header=FALSE)
testSubject<-read.table(paste(D,"test/subject_test.txt",sep="/"),header=FALSE)

# Combine train and test X                      
X<-rbind(trainX,testX)
Y<-rbind(trainY,testY)
id<-rbind(trainSubject,testSubject)

# Create characater activity vector using the activities mapping applied to 
# numerical activity vector Y
activity<-activities$V2[match(Y$V1,activities$V1)]
# Add activity and id columns to X
XY<-cbind(X,id,activity)
# Give proper headings to XY, including the new columns, using the header
# read in from the features file
varNames<-c(headX[["V2"]],"id","activity")
names(XY)<-varNames
# Per requirement, identify columns with 'mean()' or 'std()' in their names
wantedColumns<-grep("mean\\(\\)|std\\(\\)",varNames,ignore.case = TRUE)
# Append id and activity column numbers to the wanted columns column numbers
wantedColumns<-c(wantedColumns,grep("id|activity",varNames))
# Extract wanted dataset - means and standard deviations of measurements, plus
# id and activity
XYwanted <- XY[,wantedColumns]
# Order dataset
XYwanted <- arrange(XYwanted,id,activity)

# Summarize data to answer the following:

# Put one observation per id/activity in each row
# Use id.vars and not just id parameter (id -> wrong result)
XYmelted <- melt(XYwanted,id.vars=c("id","activity"))
# Aggregate data per id/activty
XYsummary<-aggregate(value~id+activity+variable,XYmelted,mean)

# Reshape summary into original data form (one variable per column)
XYfinal<-arrange(dcast(XYsummary,id+activity~variable),id,activity)

# Write tidy data to a file
write.table(XYfinal,"TidyData.txt",row.name=FALSE)


