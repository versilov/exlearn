alias ExLearn.NeuralNetwork, as: NN

# Changes cwd to the sample folder since `mix run` sets it to the project root.
:ok = File.cd("samples/mnist-digits")

# Reads the archives in memory.
{:ok, test_images_gziped    } = File.read("t10k-images-idx3-ubyte.gz")
{:ok, test_labels_gziped    } = File.read("t10k-labels-idx1-ubyte.gz")
{:ok, training_images_gziped} = File.read("train-images-idx3-ubyte.gz")
{:ok, training_labels_gziped} = File.read("train-labels-idx1-ubyte.gz")

# Extracts the binary data from the archives.
test_images_binary     = :zlib.gunzip(test_images_gziped)
test_labels_binary     = :zlib.gunzip(test_labels_gziped)
training_images_binary = :zlib.gunzip(training_images_gziped)
training_labels_binary = :zlib.gunzip(training_labels_gziped)

# Extracts the image binary data.
<<
  2051        :: size(32), # Magic number.
  10000       :: size(32), # Number of images.
  28          :: size(32), # Number of rows.
  28          :: size(32), # Number of columns.
  test_images :: binary    # All images in binary data.
>> = test_images_binary

<<
  2049        :: size(32), # Magic number.
  10000       :: size(32), # Number of labels.
  test_labels :: binary    # All labels in binary data.
>> = test_labels_binary

<<
  2051            :: size(32), # Magic number.
  60000           :: size(32), # Number of images.
  28              :: size(32), # Number of rows.
  28              :: size(32), # Number of columns.
  training_images :: binary    # All images in binary data.
>> = training_images_binary

<<
  2049            :: size(32), # Magic number.
  60000           :: size(32), # Number of labels.
  training_labels :: binary    # All labels in binary data.
>> = training_labels_binary

# Helper for extracting the image data from binary.
# Return a list of integers that will be fed to the network.
extract_image_data = fn(binary) ->
  for <<test_image :: size(8) <- test_images>>
  do test_image end
  |> Enum.chunk(28 * 28)
end

# Helper for previewing an image in the terminal.
preview_image = fn(image) ->
  Enum.chunk(image, 28)
  |> Enum.each(fn(x) ->
    Enum.each(x, fn(x) -> :io.format("~3..0B", [x]) end)
    IO.puts("")
  end)
end

# Trying out the code so far.
test_image_list = extract_image_data.(test_images)
[first, second | rest] = test_image_list
preview_image.(second)
