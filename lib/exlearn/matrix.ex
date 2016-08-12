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
    <<rows :: float-32, columns :: float-32, data :: binary>> = matrix

    initial = <<rows :: float-32, columns :: float-32>>

    apply_on_matrix(data, function, initial)
  end

  defp apply_on_matrix(<<>>, _,        accumulator), do: accumulator
  defp apply_on_matrix(data, function, accumulator)  do
    <<element :: float-32, rest :: binary>> = data
    new_element = function.(element)

    apply_on_matrix(rest, function, accumulator <> <<new_element :: float-32>>)
  end

  @doc """
  Creates a new matrix with values provided by the given function
  """
  @spec build(non_neg_integer, non_neg_integer, function) :: binary
  def build(rows, columns, function) do
    initial = <<rows :: float-32, columns :: float-32>>

    build_matrix(rows * columns, function, initial)
  end

  defp build_matrix(0,    _,        accumulator), do: accumulator
  defp build_matrix(size, function, accumulator)  do
    build_matrix(size - 1, function, accumulator <> <<function.() :: float-32>>)
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
  Transposes a matrix
  """
  @spec transpose([[]]) :: [[]]
  def transpose(_matrix) do
    exit(:nif_library_not_loaded)
  end
end
