alias ExLearn.NeuralNetwork, as: NN

:ok = File.cd("samples/mnist-digits")

{:ok, test_images_gziped    } = File.read("t10k-images-idx3-ubyte.gz")
{:ok, test_labels_gziped    } = File.read("t10k-labels-idx1-ubyte.gz")
{:ok, training_images_gziped} = File.read("train-images-idx3-ubyte.gz")
{:ok, training_labels_gziped} = File.read("train-labels-idx1-ubyte.gz")

test_images_binary     = :zlib.gunzip(test_images_gziped)
test_labels_binary     = :zlib.gunzip(test_labels_gziped)
training_images_binary = :zlib.gunzip(training_images_gziped)
training_labels_binary = :zlib.gunzip(training_labels_gziped)

<<
  2051        :: size(32),
  10000       :: size(32),
  28          :: size(32),
  28          :: size(32),
  test_images :: binary
>> = test_images_binary

<<
  2049        :: size(32),
  10000       :: size(32),
  test_labels :: binary
>> = test_labels_binary

<<
  2051            :: size(32),
  60000           :: size(32),
  28              :: size(32),
  28              :: size(32),
  training_images :: binary
>> = training_images_binary

<<
  2049            :: size(32),
  60000           :: size(32),
  training_labels :: binary
>> = training_labels_binary
