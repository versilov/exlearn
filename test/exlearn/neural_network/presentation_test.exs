defmodule ExLearn.NeuralNetwork.PresentationTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Presentation

  test "#determine returns the given function" do
    function = fn(x) -> x + 1 end

    resulting_function = Presentation.determine(function)

    assert resulting_function.(1) == 2
  end

  test "#determine returns argmax" do
    matrix = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    resulting_function = Presentation.determine(:argmax)

    assert resulting_function.(matrix) == 5
  end

  test "#determine returns argmax with offset" do
    matrix = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    setup  = {:argmax, offset: 1}
    resulting_function = Presentation.determine(setup)

    assert resulting_function.(matrix) == 6
  end

  test "#determine returns raw data" do
    matrix = Matrix.new(2, 3, [[1, 2, 3], [4, 5, 6]])
    resulting_function = Presentation.determine(:raw)

    assert resulting_function.(matrix) == matrix
  end

  test "#determine returns round" do
    matrix = Matrix.new(2, 3, [[1.1, 2, 3], [4, 5, 6]])
    resulting_function = Presentation.determine(:round)

    assert resulting_function.(matrix) === 1
  end

  test "#determine returns round with precision" do
    matrix = Matrix.new(2, 3, [[1.19, 2, 3], [4, 5, 6]])
    setup  = {:round, precision: 1}
    resulting_function = Presentation.determine(setup)

    assert resulting_function.(matrix) == 1.2
  end
end
