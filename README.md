# HandwrittenEquationRecognizer

# The MATLAB way
The project can be run using the neural network trained in Matlab using the script
main.m. Except for a working Matlab 16a installation nothing else is required and
running the script should work out of the box.

# The pythonic way
A second way to run this program is using the script main.py. This code calls the
python version of HER and uses a CNN for classifying the symbols. This trained
network gives slightly better results than its Matlab counterpart. However, getting
this running is a bit harder. The following is required:
 - A working python interpreter version 3.5 or higher
 - an installation of the Matlab engine for python (see https://au.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)
 - a working installation of Keras (see https://keras.io and for a good short installation instruction using the package manager Anaconda see http://machinelearningmastery.com/setup-python-environment-machine-learning-deep-learning-anaconda/)
With this at hand running the script should be as easy as: python main.py
Beware: As the Matlab integration does not work to well, a lot of deprecation warnings are printed!
