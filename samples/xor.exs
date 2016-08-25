alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 4}],
    output:  %{activity: :softmax,  name: "Output",       size: 2}
  },
  objective:    :negative_log_likelihood,
  presentation: :argmax
}

network = NN.create(structure_parameters)

initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0,
  modifier:     fn(value, inputs, _outputs) -> value / :math.sqrt(inputs) end
}

NN.initialize(initialization_parameters, network)

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

NN.process(data, parameters, network) |> NN.result

|> Enum.map(fn({id, output}) ->
  IO.puts "------------------------------"
  IO.puts "Input ID: #{id}"
  IO.puts "Output: #{output}"
end)
