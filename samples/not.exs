alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 1},
    hidden: [%{activity: :logistic, size: 2}],
    output:  %{activity: :tanh,     size: 1}
  },
  objective:    :quadratic,
  presentation: :round
}

initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0
}

training_data = [
  {Matrix.new(1, 1, [[0]]), Matrix.new(1, 1, [[1]])},
  {Matrix.new(1, 1, [[1]]), Matrix.new(1, 1, [[0]])},
]

prediction_data = [
  {0, Matrix.new(1, 1, [[0]])},
  {1, Matrix.new(1, 1, [[1]])}
]

data = %{
  train:   %{data: training_data,   size: 4},
  predict: %{data: prediction_data, size: 4}
}

parameters = %{
  batch_size:    1,
  epochs:        1000,
  learning_rate: 0.5,
  workers:       1
}

structure_parameters
|> NN.create
|> NN.initialize(initialization_parameters)
|> NN.process(data, parameters)
|> NN.result
|> Enum.map(fn({id, output}) ->
  IO.puts "------------------------------"
  IO.puts "Input ID: #{id}"
  IO.puts "Output: #{output}"
end)
