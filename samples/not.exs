alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 1},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 2}],
    output:  %{activity: :tanh,     name: "Output",       size: 1}
  },
  objective: :quadratic
}

network = NN.create(structure_parameters)

initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0
}

NN.initialize(initialization_parameters, network)

training_data = [
  {Matrix.new(1, 1, [[0]]), Matrix.new(1, 1, [[1]])},
  {Matrix.new(1, 1, [[1]]), Matrix.new(1, 1, [[0]])},
]

learning_parameters = %{
  training: %{
    batch_size:     1,
    data:           training_data,
    data_size:      2,
    epochs:         1000,
    learning_rate:  0.5,
    regularization: :none
  },
  workers: 1
}

NN.train(learning_parameters, network) |> Task.await(:infinity)

ask_data = [
  Matrix.new(1, 1, [[0]]),
  Matrix.new(1, 1, [[1]])
]

NN.ask(ask_data, network)
|> Task.await(:infinity)
|> Enum.map(&Matrix.inspect/1)
