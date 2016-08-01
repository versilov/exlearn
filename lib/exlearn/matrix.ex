defmodule ExLearn.Matrix do
  @moduledoc """
  Performs operations on matrices
  """

  alias ExLearn.Vector

  @on_load :load_nifs

  def load_nifs do
    :ok = :erlang.load_nif('priv/matrix', 0)
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
  @spec apply([[]], ((number) -> number)) :: [[]]
  def apply(matrix, function) do
    Enum.map(matrix, fn (row) ->
      Enum.map(row, &function.(&1))
    end)
  end

  @doc """
  Creates a new matrix with values provided by the given function
  """
  def build(rows, columns, function) do
    Stream.unfold(rows, fn
      0 -> nil
      n -> {Vector.build(columns, function), n - 1}
    end)
    |> Enum.to_list
  end

  @doc """
  Matrix multiplication
  """
  @spec dot([[]], [[]]) :: [[]]
  def dot(_first, _second) do
    exit(:nif_library_not_loaded)
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
  def multiply_with_scalar(matrix, scalar) do
    exit(:nif_library_not_loaded)
  end

  @doc """
  Substracts two matrices
  """
  @spec substract([[number]], [[number]]) :: []
  def substract(first, second) do
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
  Transposes a matrix
  """
  @spec transpose([[]]) :: [[]]
  def transpose([[]|_]), do: []
  def transpose(matrix) do
    transpose(matrix, [])
  end

  defp transpose([[]|_], accumulator) do
    Enum.reverse(accumulator)
  end

  defp transpose(matrix, accumulator) do
    heads = Enum.map(matrix, &hd/1)
    tails = Enum.map(matrix, &tl/1)

    transpose(tails, [heads|accumulator])
  end
end
