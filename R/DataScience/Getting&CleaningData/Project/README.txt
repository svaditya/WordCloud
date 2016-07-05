The below process summarizes how the script run_analysis.R works.
1. Loading the required packages
2. Reading all the relevant files in to data frames
3. Creating complete test data with activity labels and subjects mapped
4. Creating complete train data with activity labels and subjects mapped
5. Appending test and train data
6. Identifying column names with mean and standard deviation measurements
7. Subsetting Train+Test Data based on the the columns in step 6
8. Mapping activity labels to activity description
9. Grouping by Activity description and subjects
10. Summarizing the entire data based by activity description and subject