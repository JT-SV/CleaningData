This file explains how the analysis (final, tidy) file is obtained via run_analysis.R  

The run_analysis.R script works on the combined original train and test datasets (all stored in .txt files):  
    Measurements X_train, X_test  
    Activity	 y_train, y_test  
    Subject id	 subject_train,subject_test  

The analysis script  
1) Merges (vertically stacks) them: X_train and X_test, y_train and y_test, subject_train and subject_test.  
2) Creates an activity column from (integer 1-6 coded) y_train+y_test by using the activites mapping:  
   1 WALKING  
   2 WALKING_UPSTAIRS  
   3 WALKING_DOWNSTAIRS  
   4 SITTING  
   5 STANDING  
   6 LAYING  
3) Combines (horizontally) the measurement file with the subject id and activity vectors, and adds a  
   variable name header for further manipulation.  Variable names come from the features file.  
   The resulting data frame looks as follows (10299 rows, 563 columns):  

      tBodyAcc-mean()-X      tBodyAcc-mean()-Y        angle(Z,gravityMean) id       activity  
1         0.4034743       -0.01507440    [snip]      -0.43287564            1         LAYING  
2         0.2783732       -0.02056096    [snip]      -0.42759273            1         LAYING  
3         0.2765553       -0.01786855    [snip]      -0.43124421            1         LAYING  
  
                          [snip]                                        
    
  
10297     0.2733874       -0.01701062    [snip]       0.04081119           30 WALKING_UPSTAIRS  
10298     0.2896542       -0.01884304    [snip]       0.02533948           30 WALKING_UPSTAIRS  
10299     0.3515035       -0.01242312    [snip]       0.03669484           30 WALKING_UPSTAIRS  
  
4) The data is refined by identifying columns that contain mean() and std() in their names and extracting them along with the id and activity colum. The resulting dataframe is now 10299 rows, 68 columns (The process "Extracts only the measurements on the mean and standard deviation for each measurement." I have taken this to imply variables with mean() and std() and not variables like angle(Z,gravityMean). These could also be included if desired.  

5) The dataset is reshaped for later grouping via melt (here we display only one variable tBodyAcc-mean()):  
   id  activity	  variable     	     value  

  1	LAYING	tBodyAcc-mean()-X	0.4034743  
  1	SITTING	tBodyAcc-mean()-X	0.2783732  
  1	SITTING	tBodyAcc-mean()-X	0.2765553  

     [snip]  

  1	LAYING	tBodyAcc-mean()-X	0.2089642  
  1	SITTING	tBodyAcc-mean()-X	0.1445040  
  1	SITTING	tBodyAcc-mean()-X	0.2872516  
  1	SITTING	tBodyAcc-mean()-X	0.2799976  
  
     [snip]  
  
  2   LAYING	tBodyAcc-mean()-X 0.2856799  
  2   LAYING 	tBodyAcc-mean()-X 0.2720590  
  2   LAYING 	tBodyAcc-mean()-X 0.2763197  
  
     [snip]  
  
  2	STANDING tBodyAcc-mean()-X 0.2725287  
  2 	STANDING tBodyAcc-mean()-X 0.2757457  
  2 	STANDING tBodyAcc-mean()-X 0.2785959  
  
6) This data is grouped via aggregate. Note how we only have  
   one observation per subject id/activity now.  
    
    id         activity          variable       value  
1    1           LAYING tBodyAcc-mean()-X  0.22159824  
2    2           LAYING tBodyAcc-mean()-X  0.28137340  
3    3           LAYING tBodyAcc-mean()-X  0.27551685  
    [snip]  
50  20          SITTING tBodyAcc-mean()-X  0.27804544  
51  21          SITTING tBodyAcc-mean()-X  0.27753962  
52  22          SITTING tBodyAcc-mean()-X  0.27358382  
53  23          SITTING tBodyAcc-mean()-X  0.27335125  
    [snip]  
350 20 WALKING_UPSTAIRS tBodyAcc-mean()-Y -0.02822580  
351 21 WALKING_UPSTAIRS tBodyAcc-mean()-Y -0.02372187  
352 22 WALKING_UPSTAIRS tBodyAcc-mean()-Y -0.02686226  
    [snip]  
450 30         STANDING tBodyAcc-mean()-Z -0.10875621  
451  1          WALKING tBodyAcc-mean()-Z -0.11114810  
452  2          WALKING tBodyAcc-mean()-Z -0.10550036  
  
7) This data is finally reshaped into its original one-measurement-per-column format via dcast.  
    
From a bird's eye viewpoint, we look at 50 observations for each measurement variable for subject 1 for the LAYING activity.  Each observation point "is a mean or standard deviation of measurements" (in the course project vocabulary). The analysis process will further summarize these by taking the means.  
  
  id activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z  
1  1   LAYING         0.4034743       -0.01507440       -0.11816739  
2  1   LAYING         0.2783732       -0.02056096       -0.09682457  
3  1   LAYING         0.2765553       -0.01786855       -0.10762126  
4  1   LAYING         0.2795748       -0.01727572       -0.10948053  
5  1   LAYING         0.2765270       -0.01681910       -0.10798311  
6  1   LAYING         0.2781233       -0.01714630       -0.10801374  
  
  [snip]  
  
45  1   LAYING         0.3000531       -0.01808725        -0.1081839  
46  1   LAYING         0.2880942       -0.02275931        -0.1350580  
47  1   LAYING         0.2767659       -0.01806029        -0.1201318  
48  1   LAYING         0.2438979       -0.02762899        -0.1822721  
49  1   LAYING         0.1804785       -0.04253566        -0.2805611  
50  1   LAYING         0.2089642       -0.02274257        -0.1664494  
  
Mean of 50 observations for subject 1, activity LAYING, is calculated:  
  
id activity   tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z  
1  1   LAYING         0.2215982       -0.04051395        -0.1132036  
  
So the final output is the mean of means, or the mean of standard deviations.  
  
The final summary  variables lablelled like their original source data except that the interpreation is different.  They are now means of means and means of standard deviations, obtained as described above:  
  
id  
activity  
tBodyAcc-mean()-X  
tBodyAcc-mean()-Y  
tBodyAcc-mean()-Z  
tBodyAcc-std()-X  
tBodyAcc-std()-Y  
tBodyAcc-std()-Z  
tGravityAcc-mean()-X  
tGravityAcc-mean()-Y  
tGravityAcc-mean()-Z  
tGravityAcc-std()-X  
tGravityAcc-std()-Y  
tGravityAcc-std()-Z  
tBodyAccJerk-mean()-X   
tBodyAccJerk-mean()-Y  
tBodyAccJerk-mean()-Z  
tBodyAccJerk-std()-X  
tBodyAccJerk-std()-Y  
tBodyAccJerk-std()-Z  
tBodyGyro-mean()-X  
tBodyGyro-mean()-Y  
tBodyGyro-mean()-Z  
tBodyGyro-std()-X  
tBodyGyro-std()-Y  
tBodyGyro-std()-Z  
tBodyGyroJerk-mean()-X  
tBodyGyroJerk-mean()-Y  
tBodyGyroJerk-mean()-Z  
tBodyGyroJerk-std()-X  
tBodyGyroJerk-std()-Y  
tBodyGyroJerk-std()-Z  
tBodyAccMag-mean()  
tBodyAccMag-std()  
tGravityAccMag-mean()  
tGravityAccMag-std()  
tBodyAccJerkMag-mean()  
tBodyAccJerkMag-std()  
tBodyGyroMag-mean()  
tBodyGyroMag-std()  
tBodyGyroJerkMag-mean()  
tBodyGyroJerkMag-std()  
fBodyAcc-mean()-X  
fBodyAcc-mean()-Y  
fBodyAcc-mean()-Z  
fBodyAcc-std()-X  
fBodyAcc-std()-Y  
fBodyAcc-std()-Z  
fBodyAccJerk-mean()-X  
fBodyAccJerk-mean()-Y  
fBodyAccJerk-mean()-Z  
fBodyAccJerk-std()-X  
fBodyAccJerk-std()-Y  
fBodyAccJerk-std()-Z  
fBodyGyro-mean()-X  
fBodyGyro-mean()-Y  
fBodyGyro-mean()-Z  
fBodyGyro-std()-X  
fBodyGyro-std()-Y  
fBodyGyro-std()-Z  
fBodyAccMag-mean()  
fBodyAccMag-std()  
fBodyBodyAccJerkMag-mean()  
fBodyBodyAccJerkMag-std()  
fBodyBodyGyroMag-mean()  
fBodyBodyGyroMag-std()  
fBodyBodyGyroJerkMag-mean()  
fBodyBodyGyroJerkMag-std()  
  
Our final, tidy, sorted output therefore looks as follows (only first 3 variables are shown):  
  
  id           activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z  
1   1             LAYING         0.2215982      -0.040513953        -0.1132036  
2   1            SITTING         0.2612376      -0.001308288        -0.1045442  
3   1           STANDING         0.2789176      -0.016137590        -0.1106018  
4   1            WALKING         0.2773308      -0.017383819        -0.1111481  
5   1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505        -0.1075662  
6   1   WALKING_UPSTAIRS         0.2554617      -0.023953149        -0.0973020  
  
7   2             LAYING         0.2813734      -0.018158740        -0.1072456  
8   2            SITTING         0.2770874      -0.015687994        -0.1092183  
9   2           STANDING         0.2779115      -0.018420827        -0.1059085  
10  2            WALKING         0.2764266      -0.018594920        -0.1055004  
11  2 WALKING_DOWNSTAIRS         0.2776153      -0.022661416        -0.1168129  
12  2   WALKING_UPSTAIRS         0.2471648      -0.021412113        -0.1525139  
  
[ ... ]  
  
169 29             LAYING         0.2872952      -0.017196548       -0.10946207  
170 29            SITTING         0.2771800      -0.016630680       -0.11041182  
171 29           STANDING         0.2779651      -0.017260587       -0.10865907  
172 29            WALKING         0.2719999      -0.016291560       -0.10663243  
173 29 WALKING_DOWNSTAIRS         0.2931404      -0.014941215       -0.09813400  
174 29   WALKING_UPSTAIRS         0.2654231      -0.029946531       -0.11800059  
  
175 30             LAYING         0.2810339      -0.019449410       -0.10365815  
176 30            SITTING         0.2683361      -0.008047313       -0.09951545  
177 30           STANDING         0.2771127      -0.017016389       -0.10875621  
178 30            WALKING         0.2764068      -0.017588039       -0.09862471  
179 30 WALKING_DOWNSTAIRS         0.2831906      -0.017438390       -0.09997814  
180 30   WALKING_UPSTAIRS         0.2714156      -0.025331170       -0.12469749
