import numpy as np
import math

def sigmoid(x):
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
theta1 = np.loadtxt('theta1.csv', delimiter=',')
theta2 = np.loadtxt('theta2.csv', delimiter=',')
## load X
X = np.loadtxt('sampleX.csv', delimiter=',')
odds = np.loadtxt('sample_odds.csv', delimiter=',')
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
h2_op = odds * h2

# get result
result_p = largerProbPops(h2, 5)
result_op = largerProbPops(h2_op, 5)

