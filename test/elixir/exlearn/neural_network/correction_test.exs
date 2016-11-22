defmodule ExLearn.NeuralNetwork.ForwarderTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Correction

  test '#from_c returns a correction binary' do
    expected = <<
      1 :: integer-little-32, # layers
      1 :: integer-little-32, # width of biases matrix
      1 :: integer-little-32, # height of biases matrix
      1 :: integer-little-32, # content of biases matrix
      1 :: integer-little-32, # width of weights matrix
      1 :: integer-little-32, # height of weights matrix
      1 :: integer-little-32, # content of weights matrix
    >>

    assert Correction.from_c == expected
  end
end
