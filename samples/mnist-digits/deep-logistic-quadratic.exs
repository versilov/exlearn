# Using the data loading module defined in the same folder.
Code.require_file("data/data_loader.exs", __DIR__)

# Loads training and test data.
{training_data, test_data} = DataLoader.load_data

# You can inspect the data using something similar with the following:
#
# [first_sample|_] = training_data
# IO.inspect first_sample
# {first_image, first_label} = first_sample
# IO.inspect first_image
# IO.inspect first_label
# DataLoader.preview_image(first_image)

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

# Defines the training configuration.
configuration = %{
  batch_size:    50,
  data_size:     60000,
  epochs:        1,
  learning_rate: 3,
  workers:       4
}

# Starts the notifications stream.
# NN.notifications(:start, network)

NN.train(training_data, configuration, network)
|> Task.await(:infinity)

NN.ask([hd(test_data)], network)
|> Task.await(:infinity)
|> IO.inspect
