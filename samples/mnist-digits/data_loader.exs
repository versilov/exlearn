defmodule DataLoader do
  #----------------------------------------------------------------------------
  # Public API
  #----------------------------------------------------------------------------

  def convert(number_of_files) do
    [
      Task.async(fn ->
        convert_training_and_validation_data(number_of_files)
      end),
      Task.async(fn ->
        convert_test_data(number_of_files)
      end)
    ] |> Enum.each(&Task.await(&1, :infinity))

    :ok
  end

  def load(file) do
    {:ok, binary} = File.read(file)

    binary
  end

  def preview_image(image) do
    <<
      1         :: float-little-32,
      784       :: float-little-32,
      raw_image :: binary
    >> = image

    preview_image(raw_image, 1)

    image
  end

  def preview_label(label) do
    <<
      1         :: float-little-32,
      10        :: float-little-32,
      raw_label :: binary
    >> = label

    IO.inspect preview_label(raw_label, [])

    label
  end

  def load_one_sample(path) do
    {:ok, binary} = File.read(path)

    <<
      1             :: float-little-32,
      _count        :: float-little-32,
      input_length  :: float-little-32,
      _label_length :: float-little-32,
      _step         :: float-little-32,
      data          :: binary
    >> = binary

    input_size  = round(input_length) * 4

    <<
      input  :: binary-size(input_size),
      _rest  :: binary
    >> = data

    input
  end

  #----------------------------------------------------------------------------
  # Internal Functions
  #----------------------------------------------------------------------------

  defp preview_image(<<>>,  _),             do: :ok
  defp preview_image(image, current_column) do
    <<pixel :: float-little-32, rest :: binary>> = image

    :io.format("~3..0B", [trunc(pixel)])

    case current_column do
      28 ->
        IO.puts("")

        preview_image(rest, 1)
      _ ->
        preview_image(rest, current_column + 1)
    end
  end

  defp preview_label(<<>>,  accumulator), do: Enum.reverse(accumulator)
  defp preview_label(label, accumulator)  do
    <<element :: float-little-32, rest :: binary>> = label

    preview_label(rest, [trunc(element)|accumulator])
  end

  defp convert_training_and_validation_data(number_of_files) do
    data = read_training_data()

    [training_data, validation_data] = Enum.chunk(data, 50000, 50000, [])

    convert_training_data(training_data, number_of_files)
    convert_validation_data(validation_data, number_of_files)
  end

  defp convert_training_data(data, number_of_files) do
    chunk_size = trunc(Float.ceil(50000 / number_of_files))
    chunks     = Enum.chunk(data, chunk_size, chunk_size, [])
    path       = "samples/mnist-digits/data/training_data"

    write_chunks_to_file(chunks, path)
  end

  defp convert_validation_data(data, number_of_files) do
    chunk_size = trunc(Float.ceil(10000 / number_of_files))
    chunks     = Enum.chunk(data, chunk_size, chunk_size, [])
    path       = "samples/mnist-digits/data/validation_data"

    write_chunks_to_file(chunks, path)
  end

  defp convert_test_data(number_of_files) do
    data       = read_test_data()
    chunk_size = trunc(Float.ceil(10000 / number_of_files))
    chunks     = Enum.chunk(data, chunk_size, chunk_size, [])
    path       = "samples/mnist-digits/data/test_data"

    write_chunks_to_file(chunks, path)
  end

  defp write_chunks_to_file(chunks, path) do
    Enum.with_index(chunks)
    |> Enum.each(fn({chunk, index}) ->
      version      = 1
      count        = length(chunk)
      input_length = 784 + 2
      label_length = 10  + 2
      step         = 1

      initial = <<
        version      :: float-little-32,
        count        :: float-little-32,
        input_length :: float-little-32,
        label_length :: float-little-32,
        step         :: float-little-32
      >>

      binary = Enum.reduce(chunk, initial, fn(sample, accumulator) ->
        {input, expected} = sample

        accumulator <> input <> expected
      end)

      File.write(path <> "-#{index}.eld", binary)
    end)
  end

  #----------------------------------------------------------------------------
  # Reading from file and preparing data
  #----------------------------------------------------------------------------

  defp read_training_data do
    training_image_list = load_images(
      "samples/mnist-digits/data/archives/train-images-idx3-ubyte.gz",
      60000
    )
    training_label_list = load_labels(
      "samples/mnist-digits/data/archives/train-labels-idx1-ubyte.gz",
      60000
    )

    Enum.zip(training_image_list, training_label_list)
  end

  defp read_test_data do
    test_image_list = load_images(
      "samples/mnist-digits/data/archives/t10k-images-idx3-ubyte.gz",
      10000
    )
    test_label_list = load_labels(
      "samples/mnist-digits/data/archives/t10k-labels-idx1-ubyte.gz",
      10000
    )

    Enum.zip(test_image_list, test_label_list)
  end

  defp load_images(file_name, count) do
    <<
      2051        :: size(32), # Magic number, probably related to the idx3 format.
      ^count      :: size(32), # Number of images.
      28          :: size(32), # Number of rows.
      28          :: size(32), # Number of columns.
      images      :: binary    # All images in binary data.
    >> = binary_from_file(file_name)

    extract_images(images, [])
  end

  defp load_labels(file_name, count) do
    <<
      2049        :: size(32), # Magic number, probably related to the idx1 format.
      ^count      :: size(32), # Number of labels.
      labels      :: binary    # All labels in binary data.
    >> = binary_from_file(file_name)

    extract_labels(labels)
  end

  defp binary_from_file(file_name) do
    {:ok, gziped_data} = File.read(file_name)

    :zlib.gunzip(gziped_data)
  end

  #----------------------------------------------------------------------------
  # Image conversion
  #----------------------------------------------------------------------------

  defp extract_images(<<>>,   accumulator), do: accumulator
  defp extract_images(images, accumulator)  do
    <<raw_image :: binary-size(784), rest :: binary>> = images

    initial         = <<1 :: float-little-32, 784 :: float-little-32>>
    formatted_image = format_image(raw_image, initial)

    extract_images(rest, [formatted_image|accumulator])
  end

  defp format_image(<<>>,      accumulator), do: accumulator
  defp format_image(raw_image, accumulator)  do
    <<raw_pixel :: size(8), rest :: binary>> = raw_image

    formatted_pixel = <<raw_pixel :: float-little-32>>

    format_image(rest, accumulator <> formatted_pixel)
  end

  #----------------------------------------------------------------------------
  # Label conversion
  #----------------------------------------------------------------------------

  defp extract_labels(labels) do
    ten_numbers = Enum.to_list(0..9)

    extract_labels(labels, ten_numbers, [])
  end

  defp extract_labels(<<>>,   _,           accumulator), do: accumulator
  defp extract_labels(labels, ten_numbers, accumulator)  do
    <<raw_label :: size(8), rest :: binary >> = labels

    initial         = <<1 :: float-little-32, 10 :: float-little-32>>
    formatted_label = format_label(raw_label, ten_numbers, initial)

    extract_labels(rest, ten_numbers, [formatted_label|accumulator])
  end

  defp format_label(label, ten_numbers, initial) do
    Enum.reduce(ten_numbers, initial, fn(element, accumulator) ->
      binary_element = case element do
        ^label -> <<1.0 :: float-little-32>>
        _      -> <<0.0 :: float-little-32>>
      end

      accumulator <> binary_element
    end)
  end
end
