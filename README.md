run_analysis.R
========================================================

A R programming script to convert the "UCI HAR Dataset" into tidy data. For better understanding it is required to introduce the definition of tidy data:

* Each variable forms a columns
* Each observation forms a row
* Each table file stores data about one kind of observation

Once you run this script you will get a tidy data set.

Raw data
========================================================

You should download the "UCI HAR Dataset" from [Raw Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) into your workspace and set this directory ".../UCI HAR Dataset" as your working directory.

```r
setwd("~/.../UCI HAR Dataset")
```

```
## Error: no es posible cambiar el directorio de trabajo
```

... indicates your own directory

Usage
========================================================

Download "run_analysis.R" into your directory "UCI HAR Dataset" and use 

```r
source('~/.../UCI HAR Dataset/run_analysis.R')
```

```
## Warning: no fue posible abrir el archivo '/Users/kestina/.../UCI HAR
## Dataset/run_analysis.R': No such file or directory
```

```
## Error: no se puede abrir la conexión
```
... indicates your own directory

To obtain the tidy data into your Global Environment use

```r
tidydata <- run_analysis()
```

```
## Error: no se pudo encontrar la función "run_analysis"
```
Also, it is created a text file "TidyData.txt" into you working directory with the tidy data set.

### It is required to have the "plyr" and "reshape2" packages installed.


Steps to get a tidy data
========================================================

#### First of all it is merged the train and test data set, this it is done in three steps:

1. Extract the information needed and concatenate using cbind().
  * subject_test.txt: contain the subject or volunteer. It is save in a matrix using read.table() with the name subject_test.
  * y_test.txt: contain the id of the activity the volunteer perform. It is save in a matrix using read.table() with the name y_test.
  * x_test.txt: contain the measures for the activity the volunteer perform. It is save in a matrix using read.table() with the name x_test.
2. The same as before is is done with the train data set.
3. Finally the two data sets are concatenated using rbind(). First it is the test data set and the the train data set.

#### Add the labels to the messy data set

1. Extract the name of every variable from "features.txt" into a vector.
2. Named the first column as "subject", the second as "actID" and the next using the features vector we extract before.

#### Use descriptive activity names to name which activity is performing every subject

We need to extract information from "activity_labels.txt" which contain the activity ID and the corresponding name ("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING" and "LAYING") and merge this information with our messy data by the actID column.

#### Extract from the messy data the subject and activity columns plus the mean and standard deviation for each measurement

Using the grepl function we obtain a vector of booleans, where TRUE indicates the columns to maintain and FALSE the columns to discard.
We did this step twice, but the second time TRUE indicates the columns to discard and FALSE the columns to maintain.
The first time we want to maintain the columns "subject", "activity" and the mean and standard deviation for each measurement, the second time we want to discard the columns with "meanFreq()" in the label because is not directly a mean of a value.
Finally we order the information by subject and activity and we eliminate the underscores and parentheses from the labels and everything is in lower case.

#### Obtain molten data
Molten data has a new id variable 'variable', and a new column 'value', which represents the value of that observation. We now have the data in a form in which there are only id variables and a value.
This is achieved using the melt() function from the reshape2 package.

```r
MoltenData <- melt(TidyData,id=c(1,2),measure.vars=c(3:68), value.name="value")
```

```
## Error: no se pudo encontrar la función "melt"
```
#### Data with the average of each measure from tidy data for each activity and subject
Using the dcast() function from the reshape2 package. It is indicated that it is required to perform the mean of every measure for each subject and activity.

```r
CastData <- dcast(MoltenData,subject + activity ~ variable,mean) 
```

```
## Error: no se pudo encontrar la función "dcast"
```

#### Save the data into an txt file
The result tidy data it is saved in your working directory with the name TidyData.txt and then return the final tidy data
