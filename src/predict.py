import numpy as np
import scipy.io
import keras.models
import keras.utils
from keras.models import load_model
from keras.utils import np_utils

weights_file = 'python-keras/weights-improvement-06-0.79.hdf5'
# load weights
model = load_model(weights_file)

def predict(image):
    return model.predict(np.array([[np.transpose(image)]]))
#
# def load_data():
#     # load symbol data set
#     data = scipy.io.loadmat('../../data/extract/trainData.mat')
#     Y = data['y'] - 1
#     X = data['X']
#     X = X[Y[:,0].argsort(),:]
#     Y = Y[Y[:,0].argsort()]
#     X = X.reshape(X.shape[0], 1, 32, 32).astype('float32')
#     Y = np_utils.to_categorical(Y)
#     return X,Y
#
# print("Created model and loaded weights from file")
# # load dataset
# X,Y = load_data()
# # estimate accuracy on whole dataset using loaded weights
# scores = model.evaluate(X, Y, verbose=1)
# print("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))
