defmodule ExLearn.Matrix do
  @moduledoc """
  Performs operations on matrices
  """

  @on_load :load_nifs

  def load_nifs do
    :ok = :erlang.load_nif('./priv/matrix', 0)
  end

  @doc """
  Adds two matrices
  """
  @spec add([[number]], [[number]]) :: []
  def add(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Applies the given function on each element of the matrix
  """
  @spec apply(binary, ((number) -> number)) :: [[]]
  def apply(matrix, function) do
    <<
      rows    :: float-little-32,
      columns :: float-little-32,
      data    :: binary
    >> = matrix

    initial = <<rows :: float-little-32, columns :: float-little-32>>

    apply_on_matrix(data, function, initial)
  end

  defp apply_on_matrix(<<>>, _,        accumulator), do: accumulator
  defp apply_on_matrix(data, function, accumulator)  do
    <<value :: float-little-32, rest :: binary>> = data

    new_value   = function.(value)
    new_element = <<new_value :: float-little-32>>

    apply_on_matrix(rest, function, accumulator <> new_element)
  end

  @spec apply(binary, binary, ((number) -> number)) :: [[]]
  def apply(first, second, function) do
    <<
      rows       :: float-little-32,
      columns    :: float-little-32,
      first_data :: binary
    >> = first
    <<
      _           :: float-little-32,
      _           :: float-little-32,
      second_data :: binary
    >> = second

    initial = <<rows :: float-little-32, columns :: float-little-32>>

    apply_on_matrices(first_data, second_data, function, initial)
  end

  defp apply_on_matrices(<<>>, <<>>, _, accumulator), do: accumulator
  defp apply_on_matrices(first_data, second_data, function, accumulator)  do
    <<first_value  :: float-little-32, first_rest  :: binary>> = first_data
    <<second_value :: float-little-32, second_rest :: binary>> = second_data

    new_value       = function.(first_value, second_value)
    new_element     = <<new_value :: float-little-32>>
    new_accumulator = accumulator <> new_element

    apply_on_matrices(first_rest, second_rest, function, new_accumulator)
  end

  @doc """
  Divides two matrices
  """
  @spec divide([[number]], [[number]]) :: []
  def divide(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Matrix multiplication
  """
  @spec dot([[]], [[]]) :: [[]]
  def dot(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Matrix multiplication
  """
  @spec dot_and_add([[]], [[]], [[]]) :: [[]]
  def dot_and_add(_first, _second, _third) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Matrix multiplication where the second matrix needs to be transposed.
  """
  @spec dot_nt([[]], [[]]) :: [[]]
  def dot_nt(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Matrix multiplication where the first matrix needs to be transposed.
  """
  @spec dot_tn([[]], [[]]) :: [[]]
  def dot_tn(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Displays a visualization of the matrix.
  """
  @spec inspect(binary) :: binary
  def inspect(matrix) do
    <<
      rows    :: float-little-32,
      columns :: float-little-32,
      rest    :: binary
    >> = matrix

    IO.puts("Rows: #{trunc(rows)} Columns: #{trunc(columns)}")

    inspect_element(1, columns, rest)

    matrix
  end

  defp inspect_element(_, _, <<>>), do: :ok
  defp inspect_element(column, columns, elements) do
    <<element :: float-little-32, rest :: binary>> = elements

    next_column = case column do
      ^columns ->
        IO.puts(element)

        1.0
      _ ->
        IO.write("#{element} ")

        column + 1.0
    end

    inspect_element(next_column, columns, rest)
  end

  @doc """
  Elementwise multiplication of two matrices
  """
  @spec multiply([[]], [[]]) :: [[]]
  def multiply(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Elementwise multiplication of a scalar
  """
  @spec multiply_with_scalar([[]], [[]]) :: [[]]
  def multiply_with_scalar(_matrix, _scalar) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Creates a new matrix with values provided by the given function
  """
  @spec new(non_neg_integer, non_neg_integer, function) :: binary
  def new(rows, columns, function) when is_function(function, 0) do
    initial = <<rows :: float-little-32, columns :: float-little-32>>

    new_matrix_from_function(rows * columns, function, initial)
  end

  @spec new(non_neg_integer, non_neg_integer, list(list)) :: binary
  def new(rows, columns, list_of_lists) when is_list(list_of_lists) do
    initial = <<rows :: float-little-32, columns :: float-little-32>>

    Enum.reduce(list_of_lists, initial, fn(list, accumulator) ->
      accumulator <> Enum.reduce(list, <<>>, fn(element, partial) ->
        partial <> <<element :: float-little-32>>
      end)
    end)
  end

  defp new_matrix_from_function(0,    _,        accumulator), do: accumulator
  defp new_matrix_from_function(size, function, accumulator)  do
    current = <<function.() :: float-little-32>>

    new_matrix_from_function(size - 1, function, accumulator <> current)
  end

  @doc """
  Substracts two matrices
  """
  @spec substract([[number]], [[number]]) :: []
  def substract(_first, _second) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Substracts the second matrix from the first
  """
  @spec substract_inverse([[number]], [[number]]) :: []
  def substract_inverse(first, second) do
    substract(second, first)
  end

  @doc """
  Sums all elements.
  """
  @spec sum(binary) :: number
  def sum(matrix) do
    <<
      _rows    :: float-little-32,
      _columns :: float-little-32,
      data     :: binary
    >> = matrix

    sum(data, 0)
  end

  defp sum(<<>>,   accumulator), do: accumulator
  defp sum(values, accumulator)  do
    <<value :: float-little-32, rest :: binary>> = values

    sum(rest, accumulator + value)
  end

  @doc """
  Transposes a matrix
  """
  @spec transpose([[]]) :: [[]]
  def transpose(_matrix) do
    exit(:nif_library_not_loaded)
  end
end
