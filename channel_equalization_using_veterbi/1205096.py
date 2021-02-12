import numpy as np
import math
#from scipy.stats import norm
with open('params.txt','r') as f:
    h = [float(i) for i in f.readline().strip().split(' ')]
n=len(h)
with open('train.txt', 'r') as myfile:
    data= myfile.read().replace('\n', '')
    
mean =0
variance = .1
total_state = 2**n    
count_state = [0]*(2**n)
prior = [0]*(2**n)
state =0
transition_prob =[[0 for i in range(total_state)] for j in range(total_state)]
prev_state=0
miu = [0]*total_state
#prev= int(ord(data[0])-48)
for k in range(0,len(data)-n+1):
    i=k
    l=n-1
    state=0
    x_k =0
    while i<k+len(h):
        bit = int(ord(data[i])-48)
        state += 2**l * bit
        x_k += h[i-k]*bit
        l-=1
        i+=1
    if(k>0):
        transition_prob[prev_state][state]+=1
    prev_state=state
    count_state[state]+=1
    
    miu[state] += x_k + np.random.normal(0,variance)

for i in range(total_state):
    miu[i]= miu[i]/count_state[i]
    #print(miu[i])
    
for i in range(total_state):
    total = sum(transition_prob[i]);
    for j in range(total_state):
        #print(sum(transition_prob[i]))
        transition_prob[i][j] = transition_prob[i][j]/total;
        #print(transition_prob[i][j],end=' ')
    #print()
for i in range(len(count_state)):
    prior[i]= count_state[i]/sum(count_state);
    #print(prior[i])

with open('test.txt', 'r') as myfile:
    testData= myfile.read().replace('\n', '')
x =[]
for k in range(0,len(testData)-n+1,n-1):
    i=k
    l=n-1
    #state=0
    x_k =0
    while i<k+len(h):
        bit = int(ord(data[i])-48)
        #state += 2**l * bit
        x_k += h[i-k]*bit
        l-=1
        i+=1
    x_k += np.random.normal(0,variance);
    x.append(x_k)
   # math.log(prior[state]) + math.log(np.random(miu[state],variance))
viterbi = [[0 for i in range(len(x))] for j in range(total_state)]    
for i in range(total_state):
    a = math.log(abs(np.random.normal(miu[i],variance)))
    viterbi[i][0] = math.log(prior[i]) + a
   # print(viterbi[i][0])

best_path=[[0 for i in range(len(x))] for j in range(total_state)]
best_value=[[0 for i in range(len(x))] for j in range(total_state)]
for i in range(total_state):
    for j in range(1,len(x)):
        max_val =-10000
        for k in range(total_state):
            if transition_prob[k][i]<=0:
                continue
            viterbi[i][j] = viterbi[k][j-1] + math.log(transition_prob[k][i])+ \
                            math.log(abs(np.random.normal(miu[i],variance)))
           # print(viterbi[i][j])
            if viterbi[i][j]>max_val:
                max_val = viterbi[i][j]
                best_path[i][j] =k
                best_value[i][j]=max_val
max_v = max(element[0] for element in best_value)
max_v=-1000
best=[0] *len(x)
last =0
for i in range(total_state):
    for j in range(len(x)):
        if best_value[i][j] > max_v:
            last = i
            best[0] = last


i = best[0]
for j in range(len(x)-1,0,-1):
        k = best_path[i][j]
        best.append(k)
        i = k
        
stream=[]
for i in range(len(best)-2):
     stream.append(format(best[i],"0"+str(n)+"b")[0])

for i in range(n):
    stream.append(format(best[len(best)-1],"0"+str(n)+"b")[i])
print(stream)
correct =0
for i in range(len(stream)):
    if testData[i]==stream[i]:
        correct +=1
print("Accuracy: %f"%(correct/len(testData)*100))
