defmodule ExLearn.Matrix do
  @moduledoc """
  Performs operations on matrices
  """

  @on_load :load_nifs

  @spec load_nifs :: :ok
  def load_nifs do
    :ok = :erlang.load_nif('./priv/matrix', 0)
  end

  @doc """
  Adds two matrices
  """
  @spec add(binary, binary) :: binary
  def add(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Applies the given function on each element of the matrix
  """
  @spec apply(binary, function) :: binary
  def apply(matrix, function)
  when is_binary(matrix) and is_function(function, 1)
  do
    <<
      rows    :: float-little-32,
      columns :: float-little-32,
      data    :: binary
    >> = matrix

    initial = <<rows :: float-little-32, columns :: float-little-32>>

    apply_on_matrix(data, function, initial)
  end

  @spec apply(binary, function) :: binary
  def apply(matrix, function)
  when is_binary(matrix) and is_function(function, 2)
  do
    <<
      rows    :: float-little-32,
      columns :: float-little-32,
      data    :: binary
    >> = matrix

    initial = <<rows :: float-little-32, columns :: float-little-32>>
    size    = rows * columns

    apply_on_matrix(data, function, 1, size, initial)
  end

  @spec apply(binary, function) :: binary
  def apply(matrix, function)
  when is_binary(matrix) and is_function(function, 3)
  do
    <<
      rows    :: float-little-32,
      columns :: float-little-32,
      data    :: binary
    >> = matrix

    initial = <<rows :: float-little-32, columns :: float-little-32>>

    apply_on_matrix(data, function, 1, 1, columns, initial)
  end

  defp apply_on_matrix(<<>>, _,        accumulator), do: accumulator
  defp apply_on_matrix(data, function, accumulator)  do
    <<value :: float-little-32, rest :: binary>> = data

    new_value   = function.(value)
    new_element = <<new_value :: float-little-32>>

    apply_on_matrix(rest, function, accumulator <> new_element)
  end

  defp apply_on_matrix(<<>>, _, _, _, accumulator), do: accumulator
  defp apply_on_matrix(data, function, index, size, accumulator) do
    <<value :: float-little-32, rest :: binary>> = data

    new_value       = function.(value, index)
    new_element     = <<new_value :: float-little-32>>
    new_accumulator = accumulator <> new_element

    apply_on_matrix(rest, function, index + 1, size, new_accumulator)
  end

  defp apply_on_matrix(<<>>, _, _, _, _, accumulator), do: accumulator
  defp apply_on_matrix(data, function, row_index, column_index, columns, accumulator) do
    <<value :: float-little-32, rest :: binary>> = data

    new_value       = function.(value, row_index, column_index)
    new_element     = <<new_value :: float-little-32>>
    new_accumulator = accumulator <> new_element

    case column_index < columns do
      true  ->
        apply_on_matrix(rest, function, row_index, column_index + 1, columns, new_accumulator)
      false ->
        apply_on_matrix(rest, function, row_index + 1, 1, columns, new_accumulator)
    end
  end

  @spec apply(binary, binary, function) :: binary
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
  """
  @spec argmax(binary) :: non_neg_integer
  def argmax(matrix) do
    <<
      _rows    :: float-little-32,
      _columns :: float-little-32,
      first    :: float-little-32,
      rest     :: binary
    >> = matrix

    argmax(rest, 0, first, 0)
  end

  defp argmax(<<>>, _,     _,       argmax), do: argmax
  defp argmax(data, index, maximum, argmax)  do
    <<next :: float-little-32, rest :: binary>> = data

    case maximum < next do
      true  -> argmax(rest, index + 1, next,    index + 1)
      false -> argmax(rest, index + 1, maximum, argmax   )
    end
  end

  @doc """
  Divides two matrices
  """
  @spec divide(binary, binary) :: binary
  def divide(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Matrix multiplication
  """
  @spec dot(binary, binary) :: binary
  def dot(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Matrix multiplication
  """
  @spec dot_and_add(binary, binary, binary) :: binary
  def dot_and_add(first, second, third)
  when is_binary(first) and is_binary(second) and is_binary(third)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Matrix multiplication where the second matrix needs to be transposed.
  """
  @spec dot_nt(binary, binary) :: binary
  def dot_nt(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Matrix multiplication where the first matrix needs to be transposed.
  """
  @spec dot_tn(binary, binary) :: binary
  def dot_tn(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
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

    next_column = case column == columns do
      true ->
        IO.puts(element)

        1.0
      false ->
        IO.write("#{element} ")

        column + 1.0
    end

    inspect_element(next_column, columns, rest)
  end

  @doc """
  Maximum element in a matrix.
  """
  @spec max(binary) :: number
  def max(matrix) do
    <<
      _rows    :: float-little-32,
      _columns :: float-little-32,
      rest     :: binary
    >> = matrix

    matrix_max(rest, 10.0e-40)
  end

  defp matrix_max(<<>>,   maximum), do: maximum
  defp matrix_max(binary, previous) do
    <<value :: float-little-32, rest :: binary>> = binary

    case value > previous do
      true  -> matrix_max(rest, value   )
      false -> matrix_max(rest, previous)
    end
  end

  @doc """
  Elementwise multiplication of two matrices
  """
  @spec multiply(binary, binary) :: binary
  def multiply(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Elementwise multiplication of a scalar
  """
  @spec multiply_with_scalar(binary, number) :: binary
  def multiply_with_scalar(matrix, scalar)
  when is_binary(matrix) and is_number(scalar)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Creates a new matrix with values provided by the given function
  """
  @spec new(non_neg_integer, non_neg_integer, function) :: binary
  def new(rows, columns, function) when is_function(function, 0) do
    initial = <<rows :: float-little-32, columns :: float-little-32>>

    new_matrix_from_function(rows * columns, function, initial)
  end

  @spec new(non_neg_integer, non_neg_integer, function) :: binary
  def new(rows, columns, function) when is_function(function, 2) do
    initial = <<rows :: float-little-32, columns :: float-little-32>>
    size    = rows * columns

    new_matrix_from_function(size, rows, columns, function, initial)
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

  defp new_matrix_from_function(0, _, _, _, accumulator), do: accumulator
  defp new_matrix_from_function(size, rows, columns, function, accumulator)  do
    current         = <<function.(rows, columns) :: float-little-32>>
    new_accumulator = accumulator <> current

    new_matrix_from_function(size - 1, rows, columns, function, new_accumulator)
  end

  @doc """
  Substracts two matrices
  """
  @spec substract(binary, binary) :: binary
  def substract(first, second)
  when is_binary(first) and is_binary(second)
  do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end

  @doc """
  Substracts the second matrix from the first
  """
  @spec substract_inverse(binary, binary) :: binary
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

    matrix_sum(data, 0)
  end

  @spec sum(binary, atom) :: binary
  def sum(matrix, :rows) do
    <<
      rows    :: float-little-32,
      columns :: float-little-32,
      data    :: binary
    >> = matrix

    initial = <<1.0 :: float-little-32, rows :: float-little-32>>

    matrix_sum(data, 1, columns, 0, initial)
  end

  defp matrix_sum(<<>>,   accumulator), do: accumulator
  defp matrix_sum(values, accumulator)  do
    <<value :: float-little-32, rest :: binary>> = values

    matrix_sum(rest, accumulator + value)
  end

  defp matrix_sum(<<>>, _, _, _, accumulator), do: accumulator
  defp matrix_sum(values, current_column, columns, sum, accumulator)  do
    <<value :: float-little-32, rest :: binary>> = values

    new_sum = sum + value

    case current_column < columns do
      true  ->
        matrix_sum(rest, current_column + 1, columns, new_sum, accumulator)
      false ->
        matrix_sum(rest, 1, columns, 0, accumulator <> <<new_sum :: float-little-32>>)
    end
  end

  @doc """
  Transposes a matrix
  """
  @spec transpose(binary) :: binary
  def transpose(matrix) when is_binary(matrix) do
    :erlang.nif_error(:nif_library_not_loaded)

    <<>>
  end
end
