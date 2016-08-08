defmodule DataLoader do
  #----------------------------------------------------------------------------
  # Public API
  #----------------------------------------------------------------------------

  def convert(number_of_files) do
    convert_training_and_validation_data(number_of_files)
    convert_test_data(number_of_files)

    :ok
  end

  def load(file) do
    {:ok, binary} = File.read(file)

    binary |> :erlang.binary_to_term
  end

  def preview_image(image) do
    Enum.chunk(image, 28)
    |> Enum.each(fn(x) ->
      Enum.each(x, fn(x) -> :io.format("~3..0B", [x]) end)
      IO.puts("")
    end)
  end

  #----------------------------------------------------------------------------
  # Internal Functions
  #----------------------------------------------------------------------------

  defp convert_training_and_validation_data(number_of_files) do
    [
      training_data,
      validation_data
    ] = Enum.chunk(read_training_data, 50000, 50000, [])

    convert_training_data(training_data, number_of_files)
    convert_validation_data(validation_data, number_of_files)
  end

  defp convert_training_data(data, number_of_files) do
    chunk_size = trunc(Float.ceil(50000 / number_of_files))
    chunks     = Enum.chunk(data, chunk_size, chunk_size, [])

    Enum.with_index(chunks)
    |> Enum.each(fn({chunk, index}) ->
      binary = :erlang.term_to_binary(chunk)

      File.write("samples/mnist-digits/data/training_data-#{index}.eld", binary)
    end)
  end

  defp convert_validation_data(data, number_of_files) do
    chunk_size = trunc(Float.ceil(10000 / number_of_files))
    chunks     = Enum.chunk(data, chunk_size, chunk_size, [])

    Enum.with_index(chunks)
    |> Enum.each(fn({chunk, index}) ->
      binary = :erlang.term_to_binary(chunk)

      File.write("samples/mnist-digits/data/validation_data-#{index}.eld", binary)
    end)
  end

  defp convert_test_data(number_of_files) do
    data       = read_test_data
    chunk_size = trunc(Float.ceil(10000 / number_of_files))
    chunks     = Enum.chunk(data, chunk_size, chunk_size, [])

    Enum.with_index(chunks)
    |> Enum.each(fn({chunk, index}) ->
      binary = :erlang.term_to_binary(chunk)

      File.write("samples/mnist-digits/data/test_data-#{index}.eld", binary)
    end)
  end

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

    extract_images(images)
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

  defp extract_images(images) do
    extract_images(images, [], 1, [])
  end

  defp extract_images(<<>>, current, _, accumulator) do
    Enum.reverse([Enum.reverse(current)|accumulator])
  end

  defp extract_images(images, current, image_size, accumulator) do
    <<pixel :: size(8), rest :: binary>> = images

    case image_size do
      784 ->
        extract_images(
          rest,
          [],
          1,
          [Enum.reverse([pixel|current])|accumulator]
        )
      _   ->
        extract_images(
          rest,
          [pixel|current],
          image_size + 1,
          accumulator
        )
    end
  end

  defp extract_labels(labels) do
    ten_numbers = Enum.to_list(0..9)

    extract_labels(labels, ten_numbers, [])
  end

  defp extract_labels(<<>>, _,  accumulator) do
    Enum.reverse(accumulator)
  end

  defp extract_labels(labels, ten_numbers, accumulator) do
    <<label :: size(8), rest :: binary >> = labels

    result = format_label(label, ten_numbers)

    extract_labels(rest, ten_numbers, [result|accumulator])
  end

  defp format_label(label, ten_numbers) do
    Enum.map(ten_numbers, &zeroes_except_label(&1, label))
  end

  defp zeroes_except_label(element, label) do
    case element do
      ^label -> 1
      _      -> 0
    end
  end
end
