defmodule ExLearn.NeuralNetwork.RegularizationTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Regularization

  test "#determine :none gives back the identity function" do
    regularization = :none
    function       = Regularization.determine(regularization)

    assert function.(1, :not_used, :not_used) == 1
  end

  test "#determine :L1 gives back the L1 function" do
    regularization = {:L1, rate: 2}
    learning_rate  = 3
    data_size      = 4

    function = Regularization.determine(regularization)

    assert function.(-2, learning_rate, data_size) == -0.5
    assert function.(-1, learning_rate, data_size) ==  0.5
    assert function.( 0, learning_rate, data_size) ==  0
    assert function.( 1, learning_rate, data_size) == -0.5
    assert function.( 2, learning_rate, data_size) ==  0.5
  end

  test "#determine :L2 gives back the L2 function" do
    regularization = {:L2, rate: 2}
    learning_rate  = 3
    data_size      = 4

    function = Regularization.determine(regularization)

    assert function.(-2, learning_rate, data_size) ==  1
    assert function.(-1, learning_rate, data_size) ==  0.5
    assert function.( 0, learning_rate, data_size) ==  0
    assert function.( 1, learning_rate, data_size) == -0.5
    assert function.( 2, learning_rate, data_size) == -1
  end
end
