alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2, dropout: 0.2,                    },
    hidden: [%{size: 4, dropout: 0.5, activity: :logistic}],
    output:  %{size: 2, dropout: 0.5, activity: :softmax }
  },
  objective:    :negative_log_likelihood,
  presentation: :argmax
}

initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0,
  modifier:     fn(value, inputs, _outputs) -> value / :math.sqrt(inputs) end
}

training_data = [
  {Matrix.new(1, 2, [[0, 0]]), Matrix.new(1, 2, [[1, 0]])},
  {Matrix.new(1, 2, [[0, 1]]), Matrix.new(1, 2, [[0, 1]])},
  {Matrix.new(1, 2, [[1, 0]]), Matrix.new(1, 2, [[0, 1]])},
  {Matrix.new(1, 2, [[1, 1]]), Matrix.new(1, 2, [[1, 0]])}
]

prediction_data = [
  {0, Matrix.new(1, 2, [[0, 0]])},
  {1, Matrix.new(1, 2, [[0, 1]])},
  {2, Matrix.new(1, 2, [[1, 0]])},
  {3, Matrix.new(1, 2, [[1, 1]])}
]

data = %{
  train:   %{data: training_data,   size: 4},
  predict: %{data: prediction_data, size: 4}
}

parameters = %{
  batch_size:    2,
  epochs:        600,
  learning_rate: 0.4,
  workers:       2
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
