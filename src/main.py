from HER import HER
from scipy import misc
import matplotlib.pyplot as plt

image = misc.imread('../data/test/08.png', mode='RGB')

plt.figure
plt.imshow(image)
plt.draw()

plt.figure
HER(image)
#plt.imshow(HER.HER(image))

print('-------------FINISHED COMPUTATION-------------')
plt.show()
