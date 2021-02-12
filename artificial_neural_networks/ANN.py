from random import random
from math import exp

def dataset_minmax(dataset):
        minmax = list()
        stats = [[min(column), max(column)] for column in zip(*dataset)]
        return stats
 

def normalize_dataset(dataset, minmax):
        for row in dataset:
                for i in range(len(row)-1):
                        row[i] = (row[i] - minmax[i][0]) / (minmax[i][1] - minmax[i][0])
 

def weightInitialization(input_dim, hidden_layers, output_layer):
    neural_network = list()
    for index, eachNeuron in enumerate(hidden_layers):
        if index ==0:
            hidden = [{'weights': [random() for i in range(input_dim+1)]} for j in range(eachNeuron)]
        else:
            hidden = [{'weights':[random() for i in range(hidden_layers[index-1] + 1)]} for j in range(eachNeuron)]

        neural_network.append(hidden)
    output = [{'weights':[random() for i in range(hidden_layers[-1] + 1)]} for i in range(output_layer)]
    neural_network.append(output)
    return neural_network

def neuronActivation(weights, inputs):
        activation = weights[-1] #bias weight
        for i in range(len(weights)-1):
                activation += weights[i] * inputs[i]
        return activation

def activationTransfer(activation):
        return 1.0 / (1.0 + exp(-a*activation))

def activationDerivative(output):
        return a*output * (1.0 - output)

def forwardComputations(neural_network, row_data):
        inputs = row_data
        for layer in neural_network:
                new_inputs = []
                for eachNeuron in layer:
                        activation = neuronActivation(eachNeuron['weights'], inputs)
                        eachNeuron['output'] = activationTransfer(activation)
                        new_inputs.append(eachNeuron['output'])
                inputs = new_inputs
        return inputs

def backwardComputations(neural_network, expected):
        for i in reversed(range(len(neural_network))):
                layer = neural_network[i]
                errors = list()
                if i != len(neural_network)-1:
                        for j in range(len(layer)):
                                error = 0.0
                                for eachNeuron in neural_network[i + 1]:
                                        error += (eachNeuron['weights'][j] * eachNeuron['delta'])
                                errors.append(error)
                else:
                        for j in range(len(layer)):
                                eachNeuron = layer[j]
                                errors.append(expected[j] - eachNeuron['output'])
                for j in range(len(layer)):
                        eachNeuron = layer[j]
                        eachNeuron['delta'] = errors[j] * activationDerivative(eachNeuron['output'])

def updateWeights(neural_network, row_data, learn_rate):
    inputs = row_data[:-1]
    for i in range(len(neural_network)):
        inputs = row_data[:-1]
        if i != 0:
            inputs = [eachNeuron['output'] for eachNeuron in neural_network[i-1]]
        for eachNeuron in neural_network[i]:
            for k in range(len(inputs)):
                eachNeuron['weights'][k] += learn_rate * eachNeuron['delta']*inputs[k]
            eachNeuron['weights'][-1] += learn_rate * eachNeuron['delta']

def trainNeuralNetwork(network,train_dataset,output_layer):
    for i in range(iterations):
        sum_error = 0.0
        for row_data in train_dataset:
            outputs = forwardComputations(network,row_data)
            #print(outputs)
            expected = [0 for i in range(output_layer)]
            expected[int(row_data[-1])-1] = 1
            #print(expected)
            #print("Actual %s , Predicted %s\n"%(expected,outputs))
            #sum_error += sum([(expected[i]-outputs[i])**2 for i in range(len(expected))])
            backwardComputations(network, expected)
            updateWeights(network,row_data,learn_rate)
        #print('iteration %d , error=%.3f' % (i,sum_error))
            
def predict(network, row):
    outputs = forwardComputations(network, row)
    #print(outputs)
    return outputs.index(max(outputs))+1

def backPropagation(train_dataset,test_dataset):
    input_dim = len(train_dataset[0]) - 1
    output_layer = len(set([row[-1] for row in train_dataset]))
    network = weightInitialization(input_dim,hidden_layers,output_layer)
    trainNeuralNetwork(network,train_dataset,output_layer)

    predictions = list()
    for row_data in test_dataset:
        prediction = predict(network, row_data)
        predictions.append(prediction)
    return(predictions)
        
def performance(train_dataset,test_dataset):
    predicted = backPropagation(train_dataset,test_dataset)
    #print(predicted)
    actual = [row[-1] for row in test_dataset]
    #print(actual)
    match =0
    for i in range(len(actual)):
        if(int(actual[i]) ==int(predicted[i])):
            match +=1
    return (float(match)/len(actual))*100.0
    
def stringColumnToFloat(dataset, column):
        for row in dataset:
                row[column] = float(row[column].strip())

                
train_filename = "trainNN.txt"
with open(train_filename) as textFile:
    train_dataset = [line.split() for line in textFile]

test_filename= "testNN.txt"
with open(test_filename) as file:
    test_dataset = [line.split() for line in file]
    
with open("layer_configuration.txt") as f:
    hidden_layers = [int(x) for x in next(f).split()]
   
a=2.0
learn_rate = 0.7
iterations = 150

for i in range(len(train_dataset[0])):
    stringColumnToFloat(train_dataset, i)
for i in range(len(test_dataset[0])):
    stringColumnToFloat(test_dataset,i)

minmax = dataset_minmax(train_dataset)
normalize_dataset(train_dataset, minmax)

minmax = dataset_minmax(test_dataset)
normalize_dataset(test_dataset, minmax)

    
accuracy = performance(train_dataset,test_dataset)
print("Hidden Layers: %s"%hidden_layers)
print("Accuracy %.3f%%\n"%accuracy)



