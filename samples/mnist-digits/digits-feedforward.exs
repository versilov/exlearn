# Using the data loading module defined in the same folder.
# This module contains helpers for transforming the raw data from the mnist
# archives to a format that the network expects, sample loading and preview.
# To have the module available in a shell you need to give it the path relative
# to the project root:
# Code.require_file("samples/mnist-digits/data_loader.exs", __DIR__)
Code.require_file("data_loader.exs", __DIR__)

# Converts the raw data from archives to a format that the network expects.
# The parameter represent the number of files that will be created for each
# data set. The files will contain data distributed as evenly as possible.
# You only need to do this once. Comment the following line after runing it
# the first time.
DataLoader.convert(16)

# Aliasing the module names for brevity.
alias ExLearn.NeuralNetwork, as: NN

# Defines the network structure.
structure_parameters = %{
  layers: %{
    input:   %{size: 784},
    hidden: [%{activity: :logistic, size: 100}],
    output:  %{activity: :logistic, size: 10 }
  },
  objective:    :cross_entropy,
  presentation: :argmax
}

# Creates the neural network structure.
network = NN.create(structure_parameters)

# Next comes the network initialization. Skip this if you intend to load an
# already saved state.

# Defines the initialization parameters and initializes the neural network.
initialization_parameters = %{
  distribution: :uniform,
  maximum:       1,
  minimum:      -1
}

NN.initialize(initialization_parameters, network)

# If you already have a saved state you can load it with the following:
# NN.load("samples/mnist-digits/saved_network.el1", network)

# Loading an image from the test data to be added as a prediction input.
[first_sample|_] = DataLoader.load("samples/mnist-digits/data/test_data-0.eld")
{first_image, _} = first_sample

prediction_data = [{1, first_image}]

# Defines the learning data and parameters.
data = %{
  train: %{
    data: "samples/mnist-digits/data/training_data-*.eld",
    size: 50000,
  },
  validate: %{
    data: "samples/mnist-digits/data/validation_data-*.eld",
    size: 10000,
  },
  test: %{
    data: "samples/mnist-digits/data/test_data-*.eld",
    size: 10000,
  },
  predict: %{data: prediction_data, size: 1}
}

parameters = %{
  batch_size:     100,
  epochs:         50,
  learning_rate:  0.2,
  regularization: {:L2, rate: 0.0008},
  workers:        4
}

# Starts the notifications stream which will output events to stdout without
# blocking execution or the prompt.
NN.notifications(:start, network)

# Trains the network. Blocks untill the training finishes and returns the
# prediction.
result = NN.process(data, parameters, network) |> NN.result

# Stops the notification stream.
NN.notifications(:stop, network)

# Displays the prediction to stdout.
Enum.map(result, fn({id, output}) ->
  IO.puts "------------------------------"
  IO.puts "Input ID: #{id}"
  DataLoader.preview_image(first_image)

  IO.puts "Output: #{output}"
end)

# Saves the network state so it can be loaded back later.
NN.save("samples/mnist-digits/saved_network.el1", network)
