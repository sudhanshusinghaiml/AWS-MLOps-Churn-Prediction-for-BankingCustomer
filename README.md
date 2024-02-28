# AWS-MLOps-Churn-Prediction-for-BankingCustomer
This is project is for classify the churnability of the customer for a Bank. The model takes into account the important factors such as Credit Score, Geography, Gender, Age, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember and	EstimatedSalary.  

## Installation
```
$ git clone https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer.git
$ cd AWS-MLOps-Churn-Prediction-for-BankingCustomer
$ python -m venv venv/
$ source venv/Scripts/activate
$ pip install -r requirements.txt
```

## Tech Stack:
 - **Language**: Python
 - **Libraries**: Flask, gunicorn, scipy, xgboost, joblib, seaborn, scikit_learn
 - **Services:** Flask, Docker, Amazon Web Services
 - **Infrastructure as a Code:** Terraform

## Cloud Services:
 - AWS Elastic Container Registry
 - AWS CodeCommit
 - AWS CodeBuild
 - Amazon S3

## Project Approach:
 - Create the repository in github in local
 - **Application Code**
    - Flask app (app.py) is created various modules\features on the webpage as given below:
        - Home Page - It briefly describes the Project
        - Project Description - This provides the techniques and approach used for the modelling.
        - Customer Churn Prediction - It will accept the input features from webpage for single user and predict whether customer is likely to churn or not
        - Model Training - If we have a different set of data on which we want to train our model, we can copy the files in the input folder in bit bucket and Train the model from this webpage.
    - CustomerChurnPredictor - module will serve the single user inference pipeline from the webpage.
    - ModelTrainingEngine - module will serve the model training on new data from the webpage.
    - ML_Pipeline module is used for Data Preprocessing, Encoding, Outlier Treatment, Feature Scaling, Model Training, Feature Extraction.

 - Model deployment using **Docker**
    - **Prerequisite:** Install **Docker Desktop** and **Docker Toolbox**
    - Desktop or laptop should be Virtualization enabled
    - Dockerfile is created to run this application in the local desktop
    - Use the below commands to create Image and then run the container
    ```
    $ docker build -t loan_eligibility_app_image .
    $ docker run -p 5000:5000 loan_eligibility_app_image:latest
    ```
    - We can run our codes in local without Docker
    ```
    $ python app.py
    ```

- Random Forest Classifier Algorithm was selected as the best model for performance based on "Recall" as performance metrics
  * ***[Model Scores for Training Data](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/PerformanceScoreTrainingData.png)***
    
  ![Scores for Training Data](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/PerformanceScoreTrainingData.png)

  * ***[Model Scores for Validation Data](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/PerformanceScoreonValidationData.png)***
    
  ![Scores for Validation Data](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/PerformanceScoreonValidationData.png)

- Screenshot for Inference Pipeline and Model Training

  * ***[Project Details](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/ProjectDescription01.jpg)***
    
  ![Project](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/ProjectDescription01.jpg)

  ![Project](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/ProjectDescription02.jpg)

  * ***[Model Training](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/ModelTraining.jpg)***
    
  ![ModelTraining](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/ModelTraining.jpg)


  * ***[Customer Churn Prediction](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/CustomerChurnPrediction.jpg)***
    
  ![Result](https://github.com/sudhanshusinghaiml/AWS-MLOps-Churn-Prediction-for-BankingCustomer/blob/develop/outputimages/CustomerChurnPrediction.jpg)