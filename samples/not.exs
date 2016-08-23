alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 1},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 2}],
    output:  %{activity: :tanh,     name: "Output",       size: 1}
  },
  objective:    :quadratic,
  presentation: :round
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

prediction_data = [
  Matrix.new(1, 1, [[0]]),
  Matrix.new(1, 1, [[1]])
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

NN.process(data, parameters, network) |> NN.result

|> Enum.map(fn(result) ->
  %{input: input, output: output} = result

  IO.puts "------------------------------"
  IO.puts "Input:"
  Matrix.inspect input

  IO.puts "Output: #{output}"
end)
