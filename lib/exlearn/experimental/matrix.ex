defmodule ExLearn.Experimental.Matrix do
  @moduledoc """
!! This module will replace the current ExLearn.Matrix

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
The lists must all be proper lists, otherwise the function will crash.

# Example

```elixir
list_of_lists = [[1, 2, 3], [4, 5, 6]]

ExLearn.Experimental.Matrix.new(list_of_lists)
# <<2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 0, 0, 64, 64, 0, 0,
#   128, 64, 0, 0, 160, 64, 0, 0, 192, 64>>
```

# Parameters
1. `list_of_lists`: A `list` containing `lists` of the same length with values
being `integers` or `floats`.

# Return value

The function returns a `binary` with the following structure:

```
<<
  rows    :: unsigned-integer-little-32,
  columns :: unsigned-integer-little-32
  first   :: float-little-32,
  ...
>>
```

The `...` denotes potentially more elements following, equal to the number of
elements in all the sublists, all having the same data type as `first`.

# Formal proof of Correctness

THEOREM: The function produces valid output given valid input, otherwise it
produces a crash.

<1>1 LET =X= be the argument to the function.
  <2>1 CASE =X= is not a list.
    The function crashes on the first pattern match.
  <2>2 CASE =X= is an improper list.
    The function is guaranteed to crash when the `length` function is called on =X=
    due to the way `length` works.
  <2>3 CASE =X= is a proper list.
    <3>1 LET =Y= be the first element in =X=.
    <3>2 CASE =Y= is not a list.
      The function crashes on the first pattern match.
    <3>3 CASE =Y= is an improper list.
      The function is guaranteed to crash when the `length` function is called on =Y=
      due to the way `length` works.
    <3>4 CASE =Y= is a proper list.
      <4>1 LET =R= be the number of rows, equal to the length of =X=, a non negative
        integer.
      <4>2 LET =C= be the number of columns, equal to the length of =Y=, a non
        negative integer.
      <4>3 LET =I= be the initial binary, to withch the elements in =X= will be
        concatenated after being transformed in binary form. =I= conforms to the return
        value specification.
      <4>4 FOR EACH element =L= inside the list =X= traversed in order; there is at
        least one element =L= inside =X= that is a non empty proper list.
        <5>1 CASE =L= is not a list.
          The function crashes on the pattern match that extracts the head of a list.
        <5>2 CASE =L= is an improper list.
          <6>1 LET =Z= be the last element of the improper list =L=.
            When =Z= is not an empty list, the argument guard will pass it to the function
            that does a patter match in order to extract the head and tail. This pattern
            match will fail and crash the function.
        <5>3 CASE =L= is a proper list.
          <6>1 FOR EACH element =E= inside the list =L=.
            <7>1 CASE =E= is not a number.
              The function crashes when tryin to convert the term =E= into a binary
              representation of a float.
            <7>2 CASE =E= is a number.
              The term =E= is used to create a binary representation of a float which is
              concatenated to the end of an accumulator, initially containing an empty
              binary. The new accumulator is passed on to the next iteration.
            <7>3 The resulting binary is a valid binary representation of all the
              elements inside =E=.
            <7>4 The resulting binary is concatenated at the end of the binary from the
              previous iteration, or with an empty binary if we are at the start of the first
              iteration.
          <6>2 CASE There are less elements in =L= than the value of =C=.
            The list of remaining elements will be empty while the number of still to
            process elements will be greater than 0. The function will try a pattern match
            to extract head and tail from an empty list and crash.
          <6>3 CASE There are more elements in =L= than the value of =C=.
            The iterating function expects an empty list when the remaining number of
            elements is 0. When the remaining list is empty, the number of elements drops
            below 0 and no guard matches so the function crashes.
        <5>2 The resulting binary is a valid binary representation of all the elements
          inside =L=.
        <5>3 The resulting binary is concatenated at the end of the binary from the
          previous iteration, or with =I= if we are at the start of the first iteration.
      <4>5 The resulting binary is a valid binary representation of a matrix.
      <4>QED The resulting binary is returned to the caller.
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
The lists must all be proper lists, otherwise the function will crash.

Example:
```elixir
rows    = 2
columns = 3
list_of_lists = [[1, 2, 3], [4, 5, 6]]

ExLearn.Experimental.Matrix.new(rows, columns, list_of_lists)
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
  defp binary_from_list(columns, list, accumulator) when columns > 0 do
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
