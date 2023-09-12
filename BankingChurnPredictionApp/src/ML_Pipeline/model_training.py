import pandas as pd
import os
import pickle
from lightgbm import LGBMClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import recall_score

# noinspection PyUnresolvedReferences
from ML_Pipeline.categorical_encoder import CategoricalEncoder
# noinspection PyUnresolvedReferences
from ML_Pipeline.feature_extraction import AddFeatures


def data_split(df, target_variable, size, seed):
    """
        df: dataframe
        target_variable: target feature name
        size: test size ratio
        seed: random state
    """
    try:
        X = df.drop(target_variable, axis=1)
        y = df[target_variable].values
        x_train, x_test, y_train, y_test = train_test_split(X, y, test_size=size, random_state=seed)
    except Exception as e:
        print('Error in model_training.data_split function', e)
    else:
        return x_train, x_test, y_train, y_test


def training_model_pipeline(x_train, x_test, y_train, y_test):
    try:
        lgbm_model = LGBMClassifier(boosting_type='dart', num_leaves=45, max_depth=6,
                                    learning_rate=0.1, n_estimators=90, class_weight={0: 1, 1: 3},
                                    min_child_samples=20, colsample_bytree=0.6, reg_alpha=0.3,
                                    reg_lambda=1.0, n_jobs=-1, importance_type='gain', force_col_wise=True)

        lgbm_model_pipeline = Pipeline(steps=[('Feature_Encoding', CategoricalEncoder()),
                                              ('Feature_Extraction', AddFeatures()),
                                              ('classifiers', lgbm_model)
                                              ]
                                       )

        # Fit pipeline with training data
        lgbm_model_pipeline.fit(x_train, y_train)

        # Random Forest Classification Models
        RF_model = RandomForestClassifier(max_depth=7, max_features=5, min_samples_leaf=10, min_samples_split=25,
                                          n_estimators=40,
                                          class_weight='balanced', random_state=1)

        rf_model_pipeline = Pipeline(steps=[('Feature_Encoding', CategoricalEncoder()),
                                            ('Feature_Extraction', AddFeatures()),
                                            ('classifiers', RF_model)
                                            ]
                                     )

        # Fit pipeline with training data
        rf_model_pipeline.fit(x_train, y_train)

        # Decision Tree Classification Model
        dt_model = DecisionTreeClassifier(class_weight='balanced', criterion='entropy', max_depth=10,
                                          min_samples_leaf=24, min_samples_split=9)

        dt_model_pipeline = Pipeline(steps=[('Feature_Encoding', CategoricalEncoder()),
                                            ('Feature_Extraction', AddFeatures()),
                                            ('classifiers', dt_model)
                                            ]
                                     )

        # Fit pipeline with training data
        dt_model_pipeline.fit(x_train, y_train)

        models = [
            ('lightGBM', lgbm_model_pipeline),
            ('random_forest_classification', rf_model_pipeline),
            ('decision_tree', dt_model_pipeline)
        ]

        output_df = pd.DataFrame()
        columns_for_comparison = ['Model', 'Training_Recall', 'Test_Recall', 'Diff b/w Train & Test Score']

        for name, model in models:
            # Model training
            model.fit(x_train, y_train)
            y_prediction_training = model.predict(x_train)
            y_prediction_test = model.predict(x_test)

            # Evaluating Models - On Recall Scores
            training_recall = recall_score(y_train, y_prediction_training)
            test_recall = recall_score(y_test, y_prediction_test)

            difference_train_test = (training_recall - test_recall)/training_recall

            # comparison dataframe
            metrics_score = [name, training_recall, test_recall, difference_train_test]
            score_dict = dict(zip(columns_for_comparison, metrics_score))
            df_score = pd.DataFrame([score_dict])
            output_df = pd.concat([output_df, df_score], ignore_index=True)

        print(output_df.sort_values(by=['Training_Recall', 'Test_Recall'], ascending=False))

        # Saving model to disk for prediction
        filename = '../output/BankingCustomerChurnPrediction.pkl'
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, 'wb+') as f:
            pickle.dump(rf_model_pipeline, f)

    except Exception as e:
        print('Error in model_training.model_evaluation function', e)
    else:
        return models, output_df
