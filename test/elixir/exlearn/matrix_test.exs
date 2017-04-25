defmodule MatrixTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix

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
end
