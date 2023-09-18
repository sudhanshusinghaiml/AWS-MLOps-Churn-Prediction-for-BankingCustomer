import pandas as pd
import pickle
import os
import joblib


# Function to read the data file
def read_data(file_path, **kwargs):
    try:
        raw_data = pd.read_csv(file_path, **kwargs)
    except Exception as e:
        print(e)
    else:
        return raw_data


# Function to dump python objects
def pickle_dump(data, filename):
    try:
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, 'wb') as f:
            pickle.dump(data, f)
    except Exception as e:
        print(e)
    else:
        return


def joblib_dump(data, filename):
    try:
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, 'wb') as f:
            joblib.dump(data, f)
    except Exception as e:
        print(e)
    else:
        return
