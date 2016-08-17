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
DataLoader.convert(4)

# Aliasing the module names for brevity.
alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

# Defines the network structure.
structure_parameters = %{
  layers: %{
    input:   %{size: 784},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 30}],
    output:  %{activity: :logistic, name: "Output",       size: 10}
  },
  objective: :cross_entropy
}

# Creates the neural network structure.
network = NN.create(structure_parameters)

# Next comes the network initialization. Skip this if you intend to load an
# already saved state.

# Defines the initialization parameters and initializes the neural network.
initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0,
  modifier:     fn(value, inputs, _outputs) -> value / :math.sqrt(inputs) end
}

NN.initialize(initialization_parameters, network)

# If you already have a saved state you can load it with the following:
# NN.load("samples/mnist-digits/saved_network.el1", network)

# Defines the learning parameters.
learning_parameters = %{
  training: %{
    batch_size:     1000,
    data:           "samples/mnist-digits/data/training_data-*.eld",
    data_size:      50000,
    epochs:         30,
    learning_rate:  0.5,
    regularization: %{type: :L2, rate: 0.005}
  },
  validation: %{
    data:      "samples/mnist-digits/data/validation_data-*.eld",
    data_size: 10000,
  },
  test: %{
    data:      "samples/mnist-digits/data/test_data-*.eld",
    data_size: 10000,
  },
  workers: 4
}

# Starts the notifications stream which will output events to stdout without
# blocking execution or the prompt.
NN.notifications(:start, network)

# Trains the network. Blocks untill the training finishes.
NN.train(learning_parameters, network) |> Task.await(:infinity)

# Loading an image from the test data for preview.
[first_sample|_] = DataLoader.load("samples/mnist-digits/data/test_data-0.eld")
{first_image, first_label} = first_sample
DataLoader.preview_image(first_image)
DataLoader.preview_label(first_label)

ask_data = [first_image]

# Asks the network to clasify an image.
NN.ask(ask_data, network)
|> Task.await(:infinity)
|> Enum.map(&Matrix.inspect/1)

# Saves the network state so it can be loaded back later.
NN.save("samples/mnist-digits/saved_network.el1", network)
