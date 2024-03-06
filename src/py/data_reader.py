import pandas as pd

class Data_reader():
    def __init__(self, paths):
        self.return_vectors = [pd.read_csv(path)["return"].tolist() for path in paths]
    def get_return_vectors(self):
        return self.return_vectors
