import pickle
import os
import pandas as pd


def predictor(input_dict):
    try:
        CustomerId = int(input_dict['CustomerId'])
        Surname = str(input_dict['Surname'])
        CreditScore = int(input_dict['CreditScore'])
        Geography = str(input_dict['Geography'])
        Gender = str(input_dict['Gender'])
        Age = int(input_dict['Age'])
        Tenure = int(input_dict['Tenure'])
        Balance = float(input_dict['Balance'])
        NumOfProducts = int(input_dict['NumOfProducts'])
        HasCrCard = int(input_dict['HasCrCard'])
        IsActiveMember = int(input_dict['IsActiveMember'])
        EstimatedSalary = float(input_dict['EstimatedSalary'])
        RowNumber = 1
        df = [[RowNumber, CustomerId, Surname, CreditScore, Geography, Gender, Age, Tenure, Balance, NumOfProducts,
               HasCrCard, IsActiveMember, EstimatedSalary]]
        columns_list = ['RowNumber', 'CustomerId', 'Surname', 'CreditScore', 'Geography', 'Gender', 'Age', 'Tenure', 'Balance', 'NumOfProducts',
                        'HasCrCard', 'IsActiveMember', 'EstimatedSalary']
        test_df = pd.DataFrame(df, columns=columns_list)

        # Loading model to disk for prediction
        filename = '../output/BankingCustomerChurnPrediction.pkl'
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, 'rb+') as f:
            model = pickle.load(f)

        predicted_value = model.predict(test_df)
    except Exception as e:
        print('Exception in CustomerChurnPredictor.predictor', e)
    else:
        return predicted_value
