# Using the data loading module defined in the same folder.
Code.require_file("data_loader.exs", __DIR__)

# Converts the raw data from archives to a format that the library expects.
# The parameter represent the number of files for each data set.
# Files will contain data distributed as evenly as possible.
# You only need to do this once. Comment the following line after runing it
# the first time.
DataLoader.convert(4)

alias ExLearn.NeuralNetwork, as: NN

# Defines the network structure.
structure_parameters = %{
  layers: %{
    input:   %{size: 784},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 30}],
    output:  %{activity: :logistic, name: "Output",       size: 10}
  },
  objective: :quadratic,
  random:    %{distribution: :uniform, range: {-1, 1}}
}

# Initializes the neural network.
network = NN.initialize(structure_parameters)

# Defines the learning parameters.
learning_parameters = %{
  training: %{
    batch_size:    100,
    data_path:     "samples/mnist-digits/data/training_data-*.eld",
    data_size:     50000,
    epochs:        1,
    learning_rate: 3,
  },
  validation: %{
    data_path: "samples/mnist-digits/data/validation_data-*.eld",
    data_size: 10000,
  },
  test: %{
    data_path: "samples/mnist-digits/data/test_data-*.eld",
    data_size: 10000,
  },
  workers: 4
}

# Starts the notifications stream.
NN.notifications(:start, network)

NN.train(learning_parameters, network)
|> Task.await(:infinity)

[{first_image, first_label}|_] = test_data
DataLoader.preview_image(first_image)
IO.inspect first_label

ask_data = [first_image]
NN.ask(ask_data, network)
|> Task.await(:infinity)
|> IO.inspect

NN.save("samples/mnist-digits/saved_network.el1", network)
