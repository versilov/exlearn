defmodule ExLearn.Matrix do
  @moduledoc """
  Handles matrix creation, validation and conversion between binary and erlang
  term representation.
  """

  @doc """
  Creates a new matrix from a list of lists.

  Integer values are converted to floats in the final binary representation.
  The length of the top list is used to determine the number of rows.
  The length of the first list inside the top list is used to determine the
  number of columns.
  If the internal lists are not of the same length or their contents are not
  numbers then the function will crash.

  Example:
  ```elixir
  list_of_lists = [[1, 2, 3], [4, 5, 6]]

  ExLearn.Matrix.new(list_of_lists)
  # <<2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 0, 0, 64, 64, 0, 0,
  #   128, 64, 0, 0, 160, 64, 0, 0, 192, 64>>
  ```

  Parameters:
  - `list_of_lists`: A `list` containing `lists` of the same length with values
  being `integers` or `floats`.

  """

  @spec new(list(list)) :: binary
  def new(list_of_lists) do
    [first = [_|_]|_] = list_of_lists

    rows    = length(list_of_lists)
    columns = length(first)

    binary_from_list_of_lists(rows, columns, list_of_lists)
  end

  @doc """
  Creates a new matrix with the given number of rows, columns and elements from
  the provided list of lists.

  Integer values are converted to floats in the final binary representation.
  If the length of the top list does no match the `rows`, the number of elements
  in each sublist does not match the `columns`, or the elements are not all
  numbers the function will crash.

  Example:
  ```elixir
  rows    = 2
  columns = 3
  list_of_lists = [[1, 2, 3], [4, 5, 6]]

  ExLearn.Matrix.new(rows, columns, list_of_lists)
  # <<2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 0, 0, 64, 64, 0, 0,
  #   128, 64, 0, 0, 160, 64, 0, 0, 192, 64>>
  ```

  Parameters:
  - `rows`: A `non_neg_integer` representing the number of rows the matrix has.
  - `columns`: A `non_neg_integer` representing the number of columns the matrix
  has.
  - `list_of_lists`: A `list` containing `lists` of the same length with values
  being `integers` or `floats`.

  """

  @spec new(non_neg_integer, non_neg_integer, list(list)) :: binary
  def new(rows, columns, list_of_lists) do
    [first = [_|_]|_] = list_of_lists

    ^rows    = length(list_of_lists)
    ^columns = length(first)

    binary_from_list_of_lists(rows, columns, list_of_lists)
  end

  defp binary_from_list_of_lists(rows, columns, list_of_lists) do
    initial = <<
      rows    :: unsigned-integer-little-32,
      columns :: unsigned-integer-little-32
    >>

    Enum.reduce(list_of_lists, initial, fn(list, accumulator) ->
      accumulator <> binary_from_list(columns, list, <<>>)
    end)
  end

  defp binary_from_list(0,       [],   accumulator), do: accumulator
  defp binary_from_list(columns, list, accumulator)  do
    [head|tail] = list

    new_accumulator = accumulator <> <<head :: float-little-32>>

    binary_from_list(columns - 1, tail, new_accumulator)
  end

  @doc """
  Creates an erlang term representation of a matrix from a binary.
  """

  @spec from_binary(binary) :: {non_neg_integer, non_neg_integer, list(list)}
  def from_binary(binary) do
    <<
      rows    :: unsigned-integer-little-32,
      columns :: unsigned-integer-little-32,
      rest    :: binary
    >> = binary

    list_of_lists = lists_from_binary(rows, columns, 4 * columns, rest, [])

    {rows, columns, list_of_lists}
  end

  defp lists_from_binary(0, _columns, _size, <<>>, accumulator) do
    Enum.reverse(accumulator)
  end
  defp lists_from_binary(rows, columns, size, binary, accumulator) do
    <<row_binary :: binary-size(size), rest :: binary>> = binary

    row = extract_row(columns, row_binary, [])

    lists_from_binary(rows - 1, columns, size, rest, [row|accumulator])
  end

  defp extract_row(0,       <<>>,   accumulator), do: Enum.reverse(accumulator)
  defp extract_row(columns, binary, accumulator)  do
    <<element :: float-little-32, rest :: binary>> = binary

    extract_row(columns - 1, rest, [element| accumulator])
  end

  @doc """
  Creates a matrix binary from an erlang term representation.
  """

  @spec to_binary({non_neg_integer, non_neg_integer, list(list)}) :: binary
  def to_binary({rows, columns, list_of_lists}) do
    new(rows, columns, list_of_lists)
  end

  @doc """
  Checks if the argument is a valid representation of a matrix.
  """

  @spec valid?(binary) :: boolean
  def valid?(binary) do
    binary_size = bit_size(binary)

    case binary_size >= 96 do
      false -> false
      true  ->
        <<
          rows    :: unsigned-integer-little-32,
          columns :: unsigned-integer-little-32,
          rest    :: binary
        >> = binary

        bit_size(rest) == rows * columns * 32
    end
  end

  @spec valid?({non_neg_integer, non_neg_integer, list(list)}) :: boolean
  def valid?({rows, columns, list_of_lists}) do
    cond do
      not (is_number(rows)    and rows > 0)                          -> false
      not (is_number(columns) and columns > 0)                       -> false
      not (is_list(list_of_lists) and length(list_of_lists) == rows) -> false
      true ->
        valid_list_of_lists?(columns, list_of_lists)
    end
  end

  @spec valid?(any) :: false
  def valid?(_), do: false

  defp valid_list_of_lists?(_columns, []           ), do: true
  defp valid_list_of_lists?(columns,  list_of_lists)  do
    [first|rest] = list_of_lists

    cond do
      not (is_list(first) and length(first) == columns) -> false
      not contains_only_numbers?(first)                 -> false
      true ->
        valid_list_of_lists?(columns, rest)
    end
  end

  defp contains_only_numbers?([]),          do: true
  defp contains_only_numbers?([first|rest]) do
    case is_number(first) do
      false -> false
      true  -> contains_only_numbers?(rest)
    end
  end
end
