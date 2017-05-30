import numpy as np
from predict import predict
import scipy.io
import matplotlib.pyplot as plt
import matlab.engine
eng = matlab.engine.start_matlab()

# load symbol data set
latexLabel = scipy.io.loadmat('../data/extract/latexLabel.mat')['latexLabel']
newLatexLabel = []
for i in range(len(latexLabel)):
    newLatexLabel.append(latexLabel[i][0][0])
latexLabel = newLatexLabel

#def rgb2gray(rgb):
#    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])

def HER(image):
    image = matlab.double(image.tolist())
    #angle = eng.getRotationAngle(image)
    #image = eng.applyRotation(image,angle)
    #plt.figure
    #plt.imshow(image)
    #plt.show()
    #filteredImage = eng.filterImage(image)
    #plt.figure
    #plt.imshow(filteredImage)
    #plt.show()
    listBB = eng.getSymbolPositions(image)

    for i in range(len(listBB[0])):
        lx = listBB[0][i]-1
        rx = listBB[1][i]
        ly = listBB[2][i]-1
        ry = listBB[3][i]
        print(lx,rx,ly,ry)
        symbolImage = matlab.uint8((np.array(image,dtype=np.uint8)[lx:rx,ly:ry,:]).tolist())
        symbolImage = np.array(eng.rgb2gray(symbolImage))
        (xs,ys) = symbolImage.shape
        if xs<ys:
            symbolImage = np.concatenate((np.ones((np.floor((ys-xs)/2),ys)),symbolImage,np.ones((np.ceil((ys-xs)/2),ys))), axis = 0)
        if xs>ys:
            symbolImage = np.concatenate((np.ones((xs,np.floor((xs-ys)/2))),symbolImage,np.ones((xs,np.ceil((xs-ys)/2)))), axis = 1)
        symbolImage = np.array(eng.imbinarize(eng.imresize(matlab.double(symbolImage.tolist()), matlab.int64([32,32]))))
        print(symbolImage.shape)
        result = predict(symbolImage)

        print(result)
        plt.figure
        plt.imshow(symbolImage)
        plt.title('prob:%.0f\tpred:%s'%(np.max(result)*100.,latexLabel[np.argmax(result)]))
        plt.show()
