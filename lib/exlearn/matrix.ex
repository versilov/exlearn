defmodule ExLearn.Matrix do
  @moduledoc """
  Creates matrices in both binary and tuple representation.
  """

  @doc """
  Creates a new matrix.
  """

  @spec new(list(list)) :: binary
  def new(list_of_lists) when is_list(list_of_lists) do
    [first = [_|_]|_] = list_of_lists

    rows    = length(list_of_lists)
    columns = length(first)

    binary_from_list_of_lists(rows, columns, list_of_lists)
  end

  @spec new(non_neg_integer, non_neg_integer, list(list)) :: binary
  def new(rows, columns, list_of_lists) when is_list(list_of_lists) do
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
  defp binary_from_list(columns, list, accumulator) do
    [head|tail] = list

    new_accumulator = accumulator <> <<head :: float-little-32>>

    binary_from_list(columns - 1, tail, new_accumulator)
  end

  @doc """
  Creates an erlang term representation of a matrix from a binary.
  """

  @spec from_binary(binary) :: {non_neg_integer, non_neg_integer, list(list)}
  def from_binary(binary) when is_binary(binary) do
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
  def valid?(binary) when is_binary(binary) do
    true
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
      true  -> contains_only_numbers?(rest)
      false -> false
    end
  end
end
