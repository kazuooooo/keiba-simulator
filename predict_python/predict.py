import numpy as np
import math
import os
import pdb

def sigmoid(x):
  for (row,column), value in np.ndenumerate(x):
    value = x[row, column]
    if value < -709:
      x[row,column] = -709
  return 1 / (1 + np.exp(-x))

def largerProbPops(pred_vals, num):
  sample_size = pred_vals.shape[0]
  result = np.zeros([sample_size, num])
  for r in range(sample_size):
    for c in range(num):
      idx = pred_vals[r].argmax(0)
      result[r, c] = idx + 1
      pred_vals[r, idx] = 0
  return result


# prepare data
## load thetadata
base = os.path.dirname(os.path.abspath(__file__))
theta1 = np.loadtxt(os.path.normpath(os.path.join(base, './data/theta1.csv')), delimiter=',')
theta2 = np.loadtxt(os.path.normpath(os.path.join(base, './data/theta2.csv')), delimiter=',')
## load X
data = np.loadtxt(os.path.normpath(os.path.join(base, './data/machine_learning_data2016065-03:34')), delimiter=',')

X_race_info = data[:, 0:2]
X_odds = data[:, 2:18];
X_dist = data[:,18];
X_course = data[:, 19];
X_course_condition = data[:, 20];
X_rotation = data[:,21];
X_weather = data[:, 22];
X_horce_num = data[:, 23:39];
X = np.c_[X_odds, X_dist, X_course, X_horce_num];
## select horce amount
num = 5
## sample amount
m = X.shape[0]
## hotvector amount
num_labels = theta2.shape[1]
## initialize predict
p = np.zeros([m,1])
op = np.zeros([m,1])

# calc probability(forward propagation)
one_X = np.c_[np.ones([m,1]), X]
h1 = sigmoid(one_X.dot(theta1.T))
one_h1 = np.c_[np.ones([m,1]), h1]
h2 = sigmoid(one_h1.dot(theta2.T))
h2_op = X_odds * h2

# get result
result_p = np.c_[X_race_info, largerProbPops(h2, 5)]
result_op = np.c_[X_race_info, largerProbPops(h2_op, 5)]

# save as csv
np.savetxt("result_p.csv", result_p, delimiter=",", fmt='%i')
np.savetxt("result_op.csv", result_op, delimiter=",", fmt='%i')
