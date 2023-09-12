from sklearn.base import BaseEstimator
from sklearn.base import TransformerMixin
import numpy as np
import pandas as pd


class CategoricalEncoder(BaseEstimator, TransformerMixin):
    """
    Encodes categorical columns using LabelEncoding, OneHotEncoding and TargetEncoding.
    LabelEncoding is used for binary categorical columns
    OneHotEncoding is used for columns with <= 10 distinct values
    TargetEncoding is used for columns with higher cardinality (>10 distinct values)

    """

    def __init__(self, cols=None, label_encoder_cols=None, onehot_encoder_cols=None, target_encoding_cols=None,
                 reduce_df=False):
        """

        Parameters
        ----------
        cols : list of str
            Columns to encode.  Default is to one-hot/target/label encode all categorical columns in the DataFrame.
        reduce_df : bool
            Whether to use reduced degrees of freedom for encoding
            (that is, add N-1 one-hot columns for a column with N
            categories). E.g. for a column with categories A, B,
            and C: When reduce_df is True, A=[1, 0], B=[0, 1],
            and C=[0, 0].  When reduce_df is False, A=[1, 0, 0],
            B=[0, 1, 0], and C=[0, 0, 1]
            Default = False

        """

        self.global_target_mean = None
        self.sum_count = None
        self.label_encoder_maps = None
        self.onehot_encoder_maps = None
        if isinstance(cols, str):
            self.cols = [cols]
        else:
            self.cols = cols

        if isinstance(label_encoder_cols, str):
            self.label_encoder_cols = [label_encoder_cols]
        else:
            self.label_encoder_cols = label_encoder_cols

        if isinstance(onehot_encoder_cols, str):
            self.onehot_encoder_cols = [onehot_encoder_cols]
        else:
            self.onehot_encoder_cols = onehot_encoder_cols

        if isinstance(target_encoding_cols, str):
            self.target_encoding_cols = [target_encoding_cols]
        else:
            self.target_encoding_cols = target_encoding_cols

        self.reduce_df = reduce_df

    def fit(self, X, y):
        """Fit label/one-hot/target encoder to X and y

        Parameters
        ----------
        X : pandas DataFrame, shape [n_samples, n_columns]
            DataFrame containing columns to encode
        y : pandas Series, shape = [n_samples]
            Target values.

        Returns
        -------
        self : encoder
            Returns self.
        """

        # Encode all categorical cols by default
        if self.cols is None:
            self.cols = [c for c in X if str(X[c].dtype) == 'object']

        # Check columns are in X
        for col in self.cols:
            if col not in X:
                raise ValueError('Column \'' + col + '\' not in X')

        # Separating out lcols, ohecols and tcols
        if self.label_encoder_cols is None:
            self.label_encoder_cols = [c for c in self.cols if X[c].nunique() <= 2]

        if self.onehot_encoder_cols is None:
            self.onehot_encoder_cols = [c for c in self.cols if ((X[c].nunique() > 2) & (X[c].nunique() <= 10))]

        if self.target_encoding_cols is None:
            self.target_encoding_cols = [c for c in self.cols if X[c].nunique() > 10]

        # Create Label Encoding mapping
        self.label_encoder_maps = dict()
        for col in self.label_encoder_cols:
            self.label_encoder_maps[col] = dict(zip(X[col].values, X[col].astype('category').cat.codes.values))

        # Create OneHot Encoding mapping
        self.onehot_encoder_maps = dict()  # dict to store map for each column
        for col in self.onehot_encoder_cols:
            self.onehot_encoder_maps[col] = []
            uniques = X[col].unique()
            for unique in uniques:
                self.onehot_encoder_maps[col].append(unique)
            if self.reduce_df:
                del self.onehot_encoder_maps[col][-1]

        # Create Target Encoding mapping
        self.global_target_mean = y.mean().round(2)
        self.sum_count = dict()
        for col in self.target_encoding_cols:
            self.sum_count[col] = dict()
            uniques = X[col].unique()
            for unique in uniques:
                ix = X[col] == unique
                self.sum_count[col][unique] = (y[ix].sum(), ix.sum())

        # Return the fit object
        return self

    def transform(self, X, y=None):
        """Perform label/one-hot/target encoding transformation.

        Parameters
        ----------
        X : pandas DataFrame, shape [n_samples, n_columns]
            DataFrame containing columns to label encode

        Returns
        -------
        pandas DataFrame
            Input DataFrame with transformed columns
        """

        Xo = X.copy()
        # Perform label encoding transformation
        for col, lmap in self.label_encoder_maps.items():
            # Map the column
            Xo[col] = Xo[col].map(lmap)
            Xo[col].fillna(-1, inplace=True)  # Filling new values with -1

        # Perform one-hot encoding transformation
        for col, vals in self.onehot_encoder_maps.items():
            for val in vals:
                new_col = col + '_' + str(val)
                Xo[new_col] = (Xo[col] == val).astype('uint8')
            del Xo[col]

        # Perform LOO target encoding transformation
        # Use normal target encoding if this is test data
        if y is None:
            for col in self.sum_count:
                vals = np.full(X.shape[0], np.nan)
                for cat, sum_count in self.sum_count[col].items():
                    vals[X[col] == cat] = (sum_count[0] / sum_count[1]).round(2)
                Xo[col] = vals
                Xo[col].fillna(self.global_target_mean, inplace=True)  # Filling new values by global target mean

        # LOO target encode each column
        else:
            for col in self.sum_count:
                vals = np.full(X.shape[0], np.nan)
                for cat, sum_count in self.sum_count[col].items():
                    ix = X[col] == cat
                    if sum_count[1] > 1:
                        vals[ix] = ((sum_count[0] - y[ix].reshape(-1, )) / (sum_count[1] - 1)).round(2)
                    else:
                        vals[ix] = ((y.sum() - y[ix]) / (X.shape[0] - 1)).round(
                            2)  # Catering to the case where a particular
                        # category level occurs only once in the dataset

                Xo[col] = vals
                Xo[col].fillna(self.global_target_mean, inplace=True)  # Filling new values by global target mean

        # Return encoded DataFrame
        return Xo

    def fit_transform(self, X, y=None):
        """Fit and transform the data via label/one-hot/target encoding.

        Parameters
        ----------
        X : pandas DataFrame, shape [n_samples, n_columns]
            DataFrame containing columns to encode
        y : pandas Series, shape = [n_samples]
            Target values (required!).

        Returns
        -------
        pandas DataFrame
            Input DataFrame with transformed columns
        """

        return self.fit(X, y).transform(X, y)
