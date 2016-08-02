defmodule DataLoader do
  def load_data do
    training_data = Task.async(fn -> load_training_data end) |> Task.await(:infinity)
    test_data     = Task.async(fn -> load_test_data     end) |> Task.await(:infinity)

    {training_data, test_data}
  end

  defp load_training_data do
    training_image_list = load_images("samples/mnist-digits/data/train-images-idx3-ubyte.gz", 60000)
    training_label_list = load_labels("samples/mnist-digits/data/train-labels-idx1-ubyte.gz", 60000)

    Enum.zip(training_image_list, training_label_list)
  end

  defp load_test_data do
    test_image_list = load_images("samples/mnist-digits/data/t10k-images-idx3-ubyte.gz",  10000)
    test_label_list = load_labels("samples/mnist-digits/data/t10k-labels-idx1-ubyte.gz",  10000)

    Enum.zip(test_image_list, test_label_list)
  end

  def load_images(file_name, count) do
    <<
      2051        :: size(32), # Magic number, probably related to the idx3 format.
      ^count      :: size(32), # Number of images.
      28          :: size(32), # Number of rows.
      28          :: size(32), # Number of columns.
      images      :: binary    # All images in binary data.
    >> = binary_from_file(file_name)

    extract_images(images)
  end

  def load_labels(file_name, count) do
    <<
      2049        :: size(32), # Magic number, probably related to the idx1 format.
      ^count      :: size(32), # Number of labels.
      labels      :: binary    # All labels in binary data.
    >> = binary_from_file(file_name)

    extract_labels(labels)
  end

  def preview_image(image) do
    Enum.chunk(image, 28)
    |> Enum.each(fn(x) ->
      Enum.each(x, fn(x) -> :io.format("~3..0B", [x]) end)
      IO.puts("")
    end)
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

