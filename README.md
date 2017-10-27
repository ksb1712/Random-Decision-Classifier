# Random Decision Classifier
A random decision classifier based on <b>mini-max</b> principle to improve the performance of classifiers that have poor efficiency. This algorithm is based on the concept given in <b>Digital Signal Processing for Wireless Communication</b> by <b><a href = "http://www.nitt.edu/home/academics/departments/ece/faculty/asstprof/gopi/">Dr. E.S.Gopi</a></b>
# Code
The code requires two input files one "datatx.txt" is the actual label of a sample while "datarx.txt" contains the classifier's output for given samples. 
find_init.m compares the actual labels with the classifier's output while find_perf.m compares actual labels with the final output of the random classifier.
# Usage
Run the file mini_max.m. The output of the random classifier is stored in "datadetected.txt"

#Application
The application of this technique includes binary classification problems where there are many unknown parameters which results in significant drop in accuracy.
