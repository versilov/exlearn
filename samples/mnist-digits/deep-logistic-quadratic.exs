# Changes cwd to the sample folder since `mix run` sets it to the project root.
:ok = File.cd("samples/mnist-digits")

# Reads the archives in memory.
IO.puts "Started reading gzip files"
{:ok, test_images_gziped    } = File.read("t10k-images-idx3-ubyte.gz")
{:ok, test_labels_gziped    } = File.read("t10k-labels-idx1-ubyte.gz")
{:ok, training_images_gziped} = File.read("train-images-idx3-ubyte.gz")
{:ok, training_labels_gziped} = File.read("train-labels-idx1-ubyte.gz")
IO.puts "Finished reading gzip files"

# Extracts the binary data from the archives.
IO.puts "Started extracting gzip files"
test_images_binary     = :zlib.gunzip(test_images_gziped)
test_labels_binary     = :zlib.gunzip(test_labels_gziped)
training_images_binary = :zlib.gunzip(training_images_gziped)
training_labels_binary = :zlib.gunzip(training_labels_gziped)
IO.puts "Finished extracting gzip files"

# Extracts the image binary data.
<<
  2051        :: size(32), # Magic number, probably related to the idx3 format.
  10000       :: size(32), # Number of images.
  28          :: size(32), # Number of rows.
  28          :: size(32), # Number of columns.
  test_images :: binary    # All images in binary data.
>> = test_images_binary

<<
  2049        :: size(32), # Magic number, probably related to the idx1 format.
  10000       :: size(32), # Number of labels.
  test_labels :: binary    # All labels in binary data.
>> = test_labels_binary

<<
  2051            :: size(32), # Magic number, probably related to the idx3 format.
  60000           :: size(32), # Number of images.
  28              :: size(32), # Number of rows.
  28              :: size(32), # Number of columns.
  training_images :: binary    # All images in binary data.
>> = training_images_binary

<<
  2049            :: size(32), # Magic number, probably related to the idx1 format.
  60000           :: size(32), # Number of labels.
  training_labels :: binary    # All labels in binary data.
>> = training_labels_binary

# Helper for extracting the image data from binary.
# Return a list of integers that will be fed to the network.
# Each pixel is 8 bits and there is no need to split by rows.
extract_image_data = fn(binary) ->
  for <<pixel :: size(8) <- binary>> do pixel end
  |> Enum.chunk(28 * 28)
end

# Helper for extracting the image labels from binary.
# Returns a list of lists of integers (0..9) representing the label for each
# image as the network expects it.
extract_label_data = fn(binary) ->
  for <<label :: size(8) <- binary>> do
    Enum.to_list(0..9)
    |> Enum.map(fn(element) ->
      case element do
        ^label -> 1
        _      -> 0
      end
    end)
  end
end

# Helper for previewing an image in the terminal.
preview_image = fn(image) ->
  Enum.chunk(image, 28)
  |> Enum.each(fn(x) ->
    Enum.each(x, fn(x) -> :io.format("~3..0B", [x]) end)
    IO.puts("")
  end)
end

# Formatting data for the neural network.
IO.puts "Started extracting test image data and labels"
test_image_list     = extract_image_data.(test_images)
test_label_list     = extract_label_data.(test_labels)
test_data           = Enum.zip(test_image_list, test_label_list)
IO.puts "Started extracting training image data and labels"
training_image_list = extract_image_data.(training_images)
training_label_list = extract_label_data.(training_labels)
training_data       = Enum.zip(training_image_list, training_label_list)
IO.puts "Finished extracting image data and labels"

# You can inspect the data using something similar with the following:
#
# [first_sample|_] = training_data
# IO.inspect first_sample
# {first_image, first_label} = first_sample
# IO.inspect first_image
# IO.inspect first_label
# preview_image.(first_image)

alias ExLearn.NeuralNetwork, as: NN
alias ExLearn.NeuralNetwork.Logger

# Defines the network structure.
structure_parameters = %{
  layers: %{
    input:   %{size: 784},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 30}],
    output:  %{activity: :logistic, name: "Output",       size: 10}
  },
  objective: :quadratic,
  random:    %{distribution: :uniform, range: {-0.01, 0.01}}
}

# Initializes the neural network
network = NN.initialize(structure_parameters)

# Defines the training configuration
configuration = %{
  batch_size:    60000,
  data_size:     60000,
  epochs:        1,
  learning_rate: 0.05,
}

# Feeds the data to te neural network
IO.puts "Started feeding the neural network"
task = NN.feed(training_data, configuration, network)

%{logger: logger} = network
Logger.stream(logger)

IO.inspect NN.test([hd(training_data)], configuration, network)
