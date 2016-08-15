defmodule MatrixTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.Matrix

  test "#add adds two matrices" do
    first    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6 ]])
    second   = Matrix.new(2, 3, [[5, 2, 1], [3, 4, 6 ]])
    expected = Matrix.new(2, 3, [[6, 4, 4], [7, 9, 12]])

    assert Matrix.add(first, second) == expected
  end

  test "#apply/2 applies a function on each element of the matrix" do
    function = &(&1 + 1)
    input    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    expected = Matrix.new(2, 3, [[2, 3, 4], [5, 6, 7]])

    assert Matrix.apply(input, function) == expected
  end

  test "#apply/3 applies a function on each element of the matrices" do
    function = &(&1 + &2)
    first    = Matrix.new(2, 3, [[1, 2, 3], [4, 5,  6 ]])
    second   = Matrix.new(2, 3, [[2, 3, 4], [5, 6,  7 ]])
    expected = Matrix.new(2, 3, [[3, 5, 7], [9, 11, 13]])

    assert Matrix.apply(first, second, function) == expected
  end

  test "#divide divides two matrices" do
    first    = Matrix.new(2, 3, [[1,   2, 6], [9, 10, 18]])
    second   = Matrix.new(2, 3, [[2,   2, 3], [3, 5,  6 ]])
    expected = Matrix.new(2, 3, [[0.5, 1, 2], [3, 2,  3 ]])

    assert Matrix.divide(first, second) == expected
  end

  test "#dot multiplies two matrices" do
    first    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    second   = Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
    expected = Matrix.new(2, 2, [[22, 28], [49, 64]])

    assert Matrix.dot(first, second) == expected
  end

  test "#dot_and_add multiplies two matrices and adds the third" do
    first    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    second   = Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
    third    = Matrix.new(2, 2, [[1, 2], [3, 4]])
    expected = Matrix.new(2, 2, [[23, 30], [52, 68]])

    assert Matrix.dot_and_add(first, second, third) == expected
  end

  test "#dot_nt multiplies two matrices, second needing to be transposed" do
    first    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    second   = Matrix.new(2, 3, [[1, 3, 5], [2, 4, 6]])
    expected = Matrix.new(2, 2, [[22, 28], [49, 64]])

    assert Matrix.dot_nt(first, second) == expected
  end

  test "#dot_tn multiplies two matrices, first needing to be transposed" do
    first    = Matrix.new(3, 2, [[1, 4], [2, 5], [3, 6]])
    second   = Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
    expected = Matrix.new(2, 2, [[22, 28], [49, 64]])

    assert Matrix.dot_tn(first, second) == expected
  end

  test "#inspect displays a matrix visualization to stdout" do
    matrix   = Matrix.new(2, 3, [[1, 2, 3], [4,  5,  6 ]])
    expected = "Rows: 2 Columns: 3\n1.0 2.0 3.0\n4.0 5.0 6.0\n"

    output = capture_io(fn ->
      assert Matrix.inspect(matrix) == matrix
    end)

    assert output == expected
  end

  test "#multiply performs elementwise multiplication of two matrices" do
    first    = Matrix.new(2, 3, [[1, 2, 3], [4,  5,  6 ]])
    second   = Matrix.new(2, 3, [[5, 2, 1], [3,  4,  6 ]])
    expected = Matrix.new(2, 3, [[5, 4, 3], [12, 20, 36]])

    assert Matrix.multiply(first, second) == expected
  end

  test "#multiply_with_scalar multiplies matrix element by a scalar" do
    matrix   = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    scalar   = 2
    expected = Matrix.new(2, 3, [[2, 4, 6], [8, 10, 12]])

    assert Matrix.multiply_with_scalar(matrix, scalar) == expected
  end

  test "#new creates a new matrix initialized by a function" do
    rows     = 2
    columns  = 3
    function = fn -> 1 end
    expected = <<
      2 :: float-little-32, 3 :: float-little-32,
      1 :: float-little-32, 1 :: float-little-32, 1 :: float-little-32,
      1 :: float-little-32, 1 :: float-little-32, 1 :: float-little-32,
    >>

    assert Matrix.new(rows, columns, function) == expected
  end

  test "#new creates a new matrix initialized by a list" do
    rows     = 2
    columns  = 3
    list     = [[1, 2, 3], [4, 5, 6]]
    expected = <<
      2 :: float-little-32, 3 :: float-little-32,
      1 :: float-little-32, 2 :: float-little-32, 3 :: float-little-32,
      4 :: float-little-32, 5 :: float-little-32, 6 :: float-little-32,
    >>

    assert Matrix.new(rows, columns, list) == expected
  end

  test "#substract substracts two matrices" do
    first    = Matrix.new(2, 3, [[ 1, 2, 3], [4, 5, 6]])
    second   = Matrix.new(2, 3, [[ 5, 2, 1], [3, 4, 6]])
    expected = Matrix.new(2, 3, [[-4, 0, 2], [1, 1, 0]])

    assert Matrix.substract(first, second) == expected
  end

  test "#substract_inverse substracts the second matrix from the first" do
    first    = Matrix.new(2, 3, [[1, 2,  3], [ 4,  5, 6]])
    second   = Matrix.new(2, 3, [[5, 2,  1], [ 3,  4, 6]])
    expected = Matrix.new(2, 3, [[4, 0, -2], [-1, -1, 0]])

    assert Matrix.substract_inverse(first, second) == expected
  end

  test "#sum return the sum of all elements in the matrix" do
    input    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    expected = 21

    assert Matrix.sum(input) == expected
  end

  test "#transpose transposes a matrix" do
    input    = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    expected = Matrix.new(3, 2, [[1, 4], [2, 5], [3, 6]])

    assert Matrix.transpose(input) == expected
  end
end
