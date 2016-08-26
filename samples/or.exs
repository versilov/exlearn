alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, size: 2}],
    output:  %{activity: :logistic, size: 1}
  },
  objective:    :cross_entropy,
  presentation: :round
}

network = NN.create(structure_parameters)

initialization_parameters = %{
  distribution: :uniform,
  maximum:       1,
  minimum:      -1,
  modifier:     fn(value, _inputs, _outputs) -> value + 1 end
}

NN.initialize(initialization_parameters, network)

training_data = [
  {Matrix.new(1, 2, [[0, 0]]), Matrix.new(1, 2, [[0]])},
  {Matrix.new(1, 2, [[0, 1]]), Matrix.new(1, 2, [[1]])},
  {Matrix.new(1, 2, [[1, 0]]), Matrix.new(1, 2, [[1]])},
  {Matrix.new(1, 2, [[1, 1]]), Matrix.new(1, 2, [[1]])}
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
  epochs:        50,
  learning_rate: 4.5,
  workers:       2
}

NN.process(data, parameters, network) |> NN.result

|> Enum.map(fn({id, output}) ->
  IO.puts "------------------------------"
  IO.puts "Input ID: #{id}"
  IO.puts "Output: #{output}"
end)
