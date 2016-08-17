defmodule ExLearn.NeuralNetwork.ForwarderTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Forwarder

  # Netowrk mocked as following:
  # - input layer has 3 features
  # - there are 2 hidden layers
  # - h1 has 3 neurons
  # - h2 has 2 neurons
  # - output has 2 values
  #
  # I     H1    H2    O
  #   3x3   3x2   2x2
  # O     O     O     O
  # O     O     O     O
  # O     O
  setup do
    f = fn (x) -> x + 1 end
    d = fn (_) -> 1     end

    presentation = fn(x) -> x end

    state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: f, derivative: d},
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            activity: %{arity: 1, function: f, derivative: d},
            biases:   Matrix.new(1, 2, [[4, 5]]),
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            activity: %{arity: 1, function: f, derivative: d},
            biases:   Matrix.new(2, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          }
        ],
        presentation: presentation
      }
    }

    {:ok, setup: %{
      derivative: d,
      function:   f,
      state:      state,
    }}
  end

  test "#forward_for_activity returns the activities", %{setup: setup} do
    %{
      derivative: derivative,
      function:   function,
      state:      state
    } = setup

    first_input  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_input = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    first_activity = %{
      activity: [
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 3, [[31, 38, 45]]),
          output:     Matrix.new(1, 3, [[32, 39, 46]])
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[383, 501]]),
          output:     Matrix.new(1, 2, [[384, 502]])
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[1896, 2783]]),
          output:     Matrix.new(1, 2, [[1897, 2784]])
        }
      ],
      expected: Matrix.new(1, 2, [[1900, 2800]]),
      input:    Matrix.new(1, 3, [[1, 2, 3]]),
      output:   Matrix.new(1, 2, [[1897, 2784]])
    }

    second_activity = %{
      activity: [
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 3, [[43, 53, 63]]),
          output:     Matrix.new(1, 3, [[44, 54, 64]])
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[530, 693]]),
          output:     Matrix.new(1, 2, [[531, 694]])
        },
        %{
          arity:      1,
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[2619, 3845]]),
          output:     Matrix.new(1, 2, [[2620, 3846]])
        }
      ],
      expected: Matrix.new(1, 2, [[2600, 3800]]),
      input:    Matrix.new(1, 3, [[2, 3, 4]]),
      output:   Matrix.new(1, 2, [[2620, 3846]])
    }

    assert Forwarder.forward_for_activity(first_input,  state) == first_activity
    assert Forwarder.forward_for_activity(second_input, state) == second_activity
  end

  test "#forward_for_output returns the outputs", %{setup: setup} do
    %{state: state} = setup

    first_input  = Matrix.new(1, 3, [[1, 2, 3]])
    second_input = Matrix.new(1, 3, [[2, 3, 4]])

    first_expected  = Matrix.new(1, 2, [[1897, 2784]])
    second_expected = Matrix.new(1, 2, [[2620, 3846]])

    assert Forwarder.forward_for_output(first_input,  state) == first_expected
    assert Forwarder.forward_for_output(second_input, state) == second_expected
  end

  test "#forward_for_test returns the outputs and expected", %{setup: setup} do
    %{state: state} = setup

    first_input  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_input = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    first_expected = %{
      input:    Matrix.new(1, 3, [[1, 2, 3]]),
      expected: Matrix.new(1, 2, [[1900, 2800]]),
      output:   Matrix.new(1, 2, [[1897, 2784]])
    }

    second_expected = %{
      input:    Matrix.new(1, 3, [[2, 3, 4]]),
      expected: Matrix.new(1, 2, [[2600, 3800]]),
      output:   Matrix.new(1, 2, [[2620, 3846]])
    }

    assert Forwarder.forward_for_test(first_input,  state) == first_expected
    assert Forwarder.forward_for_test(second_input, state) == second_expected
  end
end
