/*CODE-01*/
/*We are importing the breast-cancer file in SAS and 
creating SAS data set LEARN.BREAST_CANCER */
PROC IMPORT DATAFILE='/folders/myfolders/Lectures/breast-cancer.xlsx'
   DBMS=XLSX
   OUT=LEARN.BREAST_CANCER
   REPLACE;
   GETNAMES=YES;
RUN;


/*CODE-02*/
/*Printing first 05 observations of the data set LEARN.BREAST_CANCER*/
   TITLE "First 05 Observations of Learn.Breast_Cancer data set";
PROC PRINT DATA=LEARN.BREAST_CANCER (OBS=5);
RUN;


/*CODE-03*/
/*We are creating variable list for Descriptive Statistics See table no.3*/
PROC CONTENTS DATA=LEARN.BREAST_CANCER VARNUM;
RUN;



/*CODE-04 to 07*/
/*For doing Logistic regression we need to transrfer the 
character variable to numeric binary class '0' and '1'*/
DATA BREAST_CANCER1;
   SET BREASTCANCER;
   IF diagnosis = 'M' THEN diagnosis = '0';
   IF diagnosis = 'B' THEN diagnosis = '1';
RUN;


DATA BREAST_CANCER2;
   SET BREAST_CANCER1;
   diagnosis_num = INPUT(diagnosis,3.);
   DROP diagnosis;
RUN;


   TITLE "FIRST 10 OBSERVATIONS FOR LEARN.BREAST_CANCER2 DATA SET";
PROC PRINT DATA=BREAST_CANCER2 (OBS=10);
RUN;


   TITLE "VARIABLE DESCRIPTION FOR LEARN.BREAST_CANCER2 DATA SET";
PROC CONTENTS DATA=BREAST_CANCER2 VARNUM;
RUN;

/*CODE-08 to 12*/
/*Now let's first build model with all variables and then select model variables, 
by chekcking by all four selection methods FORWARD, BACKWARD, STEPWISE and SCORE*/
PROC LOGISTIC DATA = BREAST_CANCER2;
   MODEL diagnosis_num = radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean 
radius_se texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst perimeter_worst
 area_worst smoothness_worst compactness_worst   concavity_worst concave_points_worst
 symmetry_worst fractal_dimension_worst;
   OUTPUT OUT = BREAST_CANCER3;
RUN;
QUIT;

PROC LOGISTIC DATA =BREAST_CANCER2;
   MODEL diagnosis_num = radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean 
radius_se texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst perimeter_worst
 area_worst smoothness_worst compactness_worst   concavity_worst concave_points_worst
 symmetry_worst fractal_dimension_worst/ SELECTION = FORWARD SLENTRY=.1 SLSTAY=.1;
   OUTPUT OUT = BREAST_CANCER3;
RUN;
QUIT;


PROC LOGISTIC DATA = BREAST_CANCER2;
   MODEL diagnosis_num = radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean 
radius_se texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst perimeter_worst
 area_worst smoothness_worst compactness_worst   concavity_worst concave_points_worst
 symmetry_worst fractal_dimension_worst/ SELECTION = BACKWARD;
   OUTPUT OUT = BREAST_CANCER3;
RUN;
QUIT;


PROC LOGISTIC DATA = BREAST_CANCER2;
   MODEL diagnosis_num = radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean 
radius_se texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst perimeter_worst
 area_worst smoothness_worst compactness_worst   concavity_worst concave_points_worst
 symmetry_worst fractal_dimension_worst/ SELECTION = STEPWISE;
   OUTPUT OUT = BREAST_CANCER3;
RUN;
QUIT;


PROC LOGISTIC DATA = BREAST_CANCER2;
   MODEL diagnosis_num = radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean 
radius_se texture_se perimeter_se area_se smoothness_se compactness_se concavity_se 
concave_points_se symmetry_se fractal_dimension_se radius_worst texture_worst perimeter_worst
 area_worst smoothness_worst compactness_worst   concavity_worst concave_points_worst
 symmetry_worst fractal_dimension_worst/ SELECTION  = SCORE;
   OUTPUT OUT = BREAST_CANCER3;
RUN;
QUIT;


/*CODE-13 to 16*/
/*From selected model by Forward and Stepwise removed colinear variables and 
tested with forward method and finally built model with 4 independent variables.*/
PROC LOGISTIC DATA = BREAST_CANCER2;
   MODEL diagnosis_num = compactness_se radius_worst texture_worst radius_se
 smoothness_worst concavity_worst concave_points_worst/ SELECTION = FORWARD SLENTRY=.1 SLSTAY=.1;
   OUTPUT OUT = BREAST_CANCER3;
RUN;
QUIT;

/*Final model with 4 independent variables*/
PROC LOGISTIC DATA = BREAST_CANCER2;
   MODEL diagnosis_num = radius_worst texture_worst smoothness_worst
  concave_points_worst/ SELECTION = FORWARD SLENTRY=.1 SLSTAY=.1;
   OUTPUT OUT = BREAST_CANCER3;
RUN;


