alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 2}],
    output:  %{activity: :tanh,     name: "Output",       size: 1}
  },
  objective: :quadratic,
  random:    %{distribution: :uniform, range: {-1, 1}}
}

network = NN.initialize(structure_parameters)

configuration = %{
  batch_size:    2,
  data_size:     4,
  epochs:        1000,
  learning_rate: 0.5,
  workers:       2
}

ask_data = [
  [0, 0],
  [0, 1],
  [1, 0],
  [1, 1]
]
training_data = [
  {[0, 0], [0]},
  {[0, 1], [0]},
  {[1, 0], [0]},
  {[1, 1], [1]}
]

NN.train(training_data, configuration, network)
|> Task.await(:infinity)

NN.ask(ask_data, network)
|> Task.await(:infinity)
|> IO.inspect
