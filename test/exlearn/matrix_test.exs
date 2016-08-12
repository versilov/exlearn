defmodule MatrixTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix

  test "#add adds two matrices" do
    first  = <<
      2 :: float-32, 3 :: float-32,
      1 :: float-32, 2 :: float-32, 3 :: float-32,
      4 :: float-32, 5 :: float-32, 6 :: float-32,
    >>
    second = <<
      2 :: float-32, 3 :: float-32,
      5 :: float-32, 2 :: float-32, 1 :: float-32,
      3 :: float-32, 4 :: float-32, 6 :: float-32,
    >>
    expected = <<
      2 :: float-32, 3 :: float-32,
      6 :: float-32, 4 :: float-32, 4  :: float-32,
      7 :: float-32, 9 :: float-32, 12 :: float-32,
    >>

    assert Matrix.add(first, second) == first
  end

  test "#apply applies a function on each element of the matrix" do
    function = &(&1 + 1)
    input    = <<
      2 :: float-32, 3 :: float-32,
      1 :: float-32, 2 :: float-32, 3 :: float-32,
      4 :: float-32, 5 :: float-32, 6 :: float-32,
    >>
    expected = <<
      2 :: float-32, 3 :: float-32,
      2 :: float-32, 3 :: float-32, 4 :: float-32,
      5 :: float-32, 6 :: float-32, 7 :: float-32,
    >>

    assert Matrix.apply(input, function) == expected
  end

  test "#build creates a new matrix" do
    rows     = 2
    columns  = 3
    function = fn -> 1 end
    expected = <<
      2 :: float-32, 3 :: float-32,
      1 :: float-32, 1 :: float-32, 1 :: float-32,
      1 :: float-32, 1 :: float-32, 1 :: float-32,
    >>

    assert Matrix.build(rows, columns, function) == expected
  end

  test "#dot multiplies two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 2], [3, 4], [5, 6]]

    expected = [[22, 28], [49, 64]]

    result = Matrix.dot(first, second)

    assert result == expected
  end

  test "#dot_and_add multiplies two matrices and adds the third" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 2], [3, 4], [5, 6]]
    third  = [[1, 2], [3, 4]]

    expected = [[23, 30], [52, 68]]

    result = Matrix.dot_and_add(first, second, third)

    assert result == expected
  end

  test "#dot_nt multiplies two matrices, second needing to be transposed" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[1, 3, 5], [2, 4, 6]]

    expected = [[22, 28], [49, 64]]

    result = Matrix.dot_nt(first, second)

    assert result == expected
  end

  test "#dot_tn multiplies two matrices, first needing to be transposed" do
    first  = [[1, 4], [2, 5], [3, 6]]
    second = [[1, 2], [3, 4], [5, 6]]

    expected = [[22, 28], [49, 64]]

    result = Matrix.dot_tn(first, second)

    assert result == expected
  end

  test "#multiply performs elementwise multiplication of two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[5, 2, 1], [3, 4, 6]]

    expected = [[5, 4, 3], [12, 20, 36]]

    result = Matrix.multiply(first, second)

    assert result == expected
  end

  test "#multiply_with_scalar multiplies matrix element by a scalar" do
    matrix   = [[1, 2, 3], [4, 5, 6]]
    scalar   = 2
    expected = [[2, 4, 6], [8, 10, 12]]

    result = Matrix.multiply_with_scalar(matrix, scalar)

    assert result == expected
  end

  test "#substract substracts two matrices" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[5, 2, 1], [3, 4, 6]]

    expected = [[-4, 0, 2], [1, 1, 0]]

    result = Matrix.substract(first, second)

    assert result == expected
  end

  test "#substract_inverse substracts the second matrix from the first" do
    first  = [[1, 2, 3], [4, 5, 6]]
    second = [[5, 2, 1], [3, 4, 6]]

    expected = [[4, 0, -2], [-1, -1, 0]]

    result = Matrix.substract_inverse(first, second)

    assert result == expected
  end


  test "#transpose transposes a matrix" do
    input    = [[1, 2, 3], [4, 5, 6]]
    expected = [[1, 4], [2, 5], [3, 6]]

    result = Matrix.transpose(input)

    assert result == expected
  end
end
