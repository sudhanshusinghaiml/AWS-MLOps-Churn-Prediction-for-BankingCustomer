from flask import Flask, request, render_template
from flask_cors import cross_origin
from ModelTrainingEngine import model_training_pipeline
import CustomerChurnPredictor

# 1. Create the application object
BankingChurnPredictionApp = Flask(__name__)


# 2. Index route, opens automatically on http://127.0.0.1:8000
@BankingChurnPredictionApp.route('/')
def index():
    heading = 'Banking Customer Churn Prediction Application'
    return render_template("home.html", heading=heading)


# 3. Routing to Home Page of "Banking Churn Prediction App"
@BankingChurnPredictionApp.route('/home.html')
def back_to_index():
    heading = 'Banking Customer Churn Prediction Application'
    return render_template("home.html", heading=heading)


# 4. Routing to Page that displays Project Descriptions
@BankingChurnPredictionApp.route('/describeChurnPrediction.html')
@cross_origin()
def home():
    heading = 'Banking Customer Churn Prediction Application'
    return render_template('/describeChurnPrediction.html', heading=heading)


# 5. Expose the prediction functionality, make a prediction from the passed
#    JSON data and return the predicted price with the confidence
#    (http://127.0.0.1:8000/predict-banking-customer-churn)
@BankingChurnPredictionApp.route('/predictBankingCustomerChurn.html', methods=['GET', 'POST'])
@cross_origin()
def predict_banking_customer_churn():
    result_string = ''
    if request.method == 'POST':
        to_predict_dict = request.form.to_dict()
        result = CustomerChurnPredictor.predictor(to_predict_dict)
        if result == 1:
            result_string = 'Yes, customer is likely to churn'
        else:
            result_string = 'No, customer is not likely to churn'

    return render_template('predictBankingCustomerChurn.html', prediction_text=result_string)


# 6. Expose the Model Training functionality with new set of Data
#    (http://127.0.0.1:8000/training-banking-customer-churn)
@BankingChurnPredictionApp.route('/trainingBankingCustomerChurnModel.html', methods=['GET', 'POST'])
@cross_origin()
def training_banking_customer_churn():
    status = ' '
    if request.method == "POST":
        model_training_flag = float(request.form["RetrainModel"])
        if model_training_flag == 1:
            flag = model_training_pipeline()
            if flag:
                status = "Model Training Completed"
            else:
                status = "Model Training did not complete. It has some errors"
        else:
            status = "Model Training was selected as No"

    return render_template("trainingBankingCustomerChurnModel.html", model_training_status=status)


# 7. Run the API with uvicorn
#    Will run on http://127.0.0.1:8000
if __name__ == '__main__':
    BankingChurnPredictionApp.run(debug=True)
    BankingChurnPredictionApp.config['TEMPLATES_AUTO_RELOAD'] = True
