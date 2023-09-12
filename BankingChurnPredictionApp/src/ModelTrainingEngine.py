from ML_Pipeline.model_training import data_split
from ML_Pipeline.model_training import create_model_pipeline
from ML_Pipeline.model_training import model_evaluation
from ML_Pipeline.utils import read_data
from ML_Pipeline.utils import pickle_dump

import pandas as pd


def model_training_pipeline():
    """
        Calls CategoricalEncoder.py function for data cleaning and encoding.
        Calls AddFeatures.py to add more from other features in the dataset.
        Calls CustomScaler.py methods to train the data on Distance based ML Algorithms

        Returns
        -------
        True - on Successful execution of function
    """
    try:
        df = read_data('../input/BankingCustomerData.csv', )

        x_train, x_test, y_train, y_test = data_split(df, 'Exited', 0.30, 1234)

        models_list = create_model_pipeline(x_train, y_train)

        metrics_df = model_evaluation(x_train, x_test, y_train, y_test, models_list)

        pd.set_option('display.max_columns', None)
        pd.set_option('display.max_rows', None)

        print(metrics_df.sort_values(by=['Training_Recall', 'Test_Recall'], ascending=False))
        dump_model_name = models_list[1]
        pickle_dump(dump_model_name, '../output/BankingCustomerChurnPrediction.sav')
    except Exception as e:
        print('Error in ModelTrainingEngine.model_training_pipeline', e)
    else:
        return True
