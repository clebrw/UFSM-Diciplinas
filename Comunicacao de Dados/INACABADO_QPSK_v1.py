from matplotlib import pyplot as plt
from math import pi, sin, cos
from random import random
import numpy as np

data = [0,1,0,0,1,0,1,0]
Nb = len(data);
f = 100000 # 100khz
T = 1.0/f  # 
t = []

for i in range(0,100):
	t.append(i*T)

data_NRZ =[]

for i in data:
	data_NRZ.append(2*i-1)

# iq_data = np.reshape(data_NRZ, (2,4))
iq_data = [0,1,0,1]

print(iq_data)

#plt.plot()
#plt.show()

y1 = []
y2 = []
No = []
Y = []
Tx = []
cosseno = []
seno = []

for i in range(4):
	for j in range(len(t)):
		# y1.append(iq_data[0,i]*cos(2*pi*f*t[j]))
		# y1.append(iq_data[i]*cos(2*pi*f*t[j]))
		# y2.append(iq_data[1,i]*sin(2*pi*f*t[j]))
		# No.append(random())
		print(float(cos(2.0*pi*f*t[j])))
	
# for i in range(4):
# for j in range(100):
# 	print(iq_data[0,i])
	# y2.append(iq_data(1,i)*sin(2*pi*f*t[j]))
	# No.append(random())
	

Y = y1+y2	
Tx = y1+y2+No   #Sinal com ruido

plt.plot(t, Y[:100])
plt.show()

# print(Y[:100])