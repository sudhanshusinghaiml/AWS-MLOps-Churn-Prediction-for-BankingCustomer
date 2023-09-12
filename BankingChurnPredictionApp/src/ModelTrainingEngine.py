from ML_Pipeline.model_training import data_split
from ML_Pipeline.model_training import training_model_pipeline
from ML_Pipeline.utils import read_data
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

        x_train, x_test, y_train, y_test = data_split(df, 'Exited', 0.10, 42)

        metrics_df, models_list = training_model_pipeline(x_train, x_test, y_train, y_test)

        pd.set_option('display.max_columns', None)
        pd.set_option('display.max_rows', None)

    except Exception as e:
        print('Error in ModelTrainingEngine.model_training_pipeline', e)
    else:
        return True
