alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 4}],
    output:  %{activity: :softmax,  name: "Output",       size: 2}
  },
  objective: :negative_log_likelihood
}

network = NN.create(structure_parameters)

initialization_parameters = %{distribution: :uniform, range: {-1, 1}}
NN.initialize(initialization_parameters, network)

training_data = [
  {[0, 0], [1, 0]},
  {[0, 1], [0, 1]},
  {[1, 0], [0, 1]},
  {[1, 1], [1, 0]}
]

learning_parameters = %{
  training: %{
    batch_size:     2,
    data:           training_data,
    data_size:      4,
    epochs:         600,
    learning_rate:  0.4,
    regularization: %{type: :L2, rate: 0.05}
  },
  workers: 2
}

NN.train(learning_parameters, network) |> Task.await(:infinity)

ask_data = [
  [0, 0],
  [0, 1],
  [1, 0],
  [1, 1]
]

NN.ask(ask_data, network) |> Task.await(:infinity) |> IO.inspect
