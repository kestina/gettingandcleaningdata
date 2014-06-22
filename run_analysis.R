run_analysis <- function(){
  
  # Required packages
  library(plyr)
  library(reshape2)
  
  # Merge test and train data
    
  # First the test data is concatenated with cbind
  subject_test <- read.table("test/subject_test.txt")
  y_test <- read.table("test/y_test.txt")
  x_test <- read.table("test/x_test.txt")
  testdata <- cbind(subject_test,y_test,x_test)
  
  # Second the train data is concatenated with cbind
  subject_train <- read.table("train/subject_train.txt")
  y_train <- read.table("train/y_train.txt")
  x_train <- read.table("train/x_train.txt")
  traindata <- cbind(subject_train,y_train,x_train)
  
  # Finally the train and test data is concatenated with rbind
  messydata <- rbind(testdata,traindata)
  
  # Add the labels to our dataset
  # Extract the name of every variable of feature
  features <- read.table("features.txt")
  namesfeatures <- features$V2
  vectorfeatures <- as.vector(namesfeatures)
  
  # Assign a label to every column of our messy data
  names(messydata) <- c("subject","actID",vectorfeatures)
  
  # Use descriptive activity names to name which activity is performing every subject
  activitylabels <- read.table("activity_labels.txt")
  names(activitylabels) <- c("actID", "activity")
  mergedata <- merge(activitylabels,messydata,by.x="actID", by.y="actID")
  
  # Reorder the data
  Data <- mergedata[,c(3,2,1,4:563)]
  
  # Extract from Data the subject and activity columns plus the mean and 
  # standard deviation for each measurement
  selectcols <- grepl('mean()|std()|subject|activity',names(Data))
  data1 <- Data[selectcols]
  
  # Discard the columns with the meanFreq() because is not directly a mean of a value
  nomeanfreq <- grepl('meanFreq()',names(data1))
  data2 <- data1[!nomeanfreq]
  
  # Order the data by the subject and its activity
  TidyData <- arrange(data2, data2$subject, data2$activity)
  
  # Eliminate the underscores and parentheses and use lower case for the labels of the data set
  names(TidyData) <- gsub("-","",tolower(names(TidyData)))
  names(TidyData) <- gsub("\\(","",names(TidyData))
  names(TidyData) <- gsub(")","",names(TidyData))
  
    
  # Obtain molten data specifying the ids and measures in the tidy data
  MoltenData <- melt(TidyData,id=c(1,2),measure.vars=c(3:68), value.name="value")
  
  # Data with the average of each measure from tidy data for each activity and subject
  CastData <- dcast(MoltenData,subject + activity ~ variable,mean)  
  
  # Save the data into an txt file
  write.table(CastData,"TidyData.txt")
  
  # Return the final tidy data
  CastData
}
  