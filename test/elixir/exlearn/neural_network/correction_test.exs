defmodule ExLearn.NeuralNetwork.CorrectionTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Correction

  test '#from_c returns a correction binary' do
    expected = <<
      # layers
      1 :: integer-little-32,
      # biases
      1 :: integer-little-32,
      2 :: integer-little-32,
      0.0 :: float-little-32, 1.0 :: float-little-32,
      # weights
      2 :: integer-little-32,
      2 :: integer-little-32,
      0.0 :: float-little-32, 1.0 :: float-little-32,
      2.0 :: float-little-32, 3.0 :: float-little-32,
    >>

    assert Correction.from_c == expected
  end
end
