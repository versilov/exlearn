alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 2}],
    output:  %{activity: :logistic, name: "Output",       size: 1}
  },
  objective: :cross_entropy
}

network = NN.create(structure_parameters)

initialization_parameters = %{distribution: :uniform, range: {-1, 1}}
NN.initialize(initialization_parameters)

training_data = [
  {[0, 0], [0]},
  {[0, 1], [1]},
  {[1, 0], [1]},
  {[1, 1], [1]}
]

learning_parameters = %{
  training: %{
    batch_size:    2,
    data:          training_data,
    data_size:     4,
    epochs:        50,
    learning_rate: 4.5,
  },
  workers: 2
}

NN.train(training_data, configuration, network) |> Task.await(:infinity)

ask_data = [
  [0, 0],
  [0, 1],
  [1, 0],
  [1, 1]
]

NN.ask(ask_data, network) |> Task.await(:infinity) |> IO.inspect
