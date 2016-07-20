alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 4}],
    output:  %{activity: :softmax,  name: "Output",       size: 2}
  },
  objective: :negative_log_likelihood,
  random:    %{distribution: :uniform, range: {-0.01, 0.01}}
}

network = NN.initialize(structure_parameters)

training_data = [
  {[0, 0], [1, 0]},
  {[0, 1], [0, 1]},
  {[1, 0], [0, 1]},
  {[1, 1], [1, 0]}
]

configuration = %{
  batch_size:     2,
  data_size:      4,
  epochs:         6000,
  dropout:        0.5,
  learning_rate:  0.2,
  regularization: :L2
}

NN.feed(training_data, configuration, network)

ask_data = [[0, 0], [0, 1], [1, 0], [1, 1]]

result = NN.ask(ask_data, network)

IO.inspect result
