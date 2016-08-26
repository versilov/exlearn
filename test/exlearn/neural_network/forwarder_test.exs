defmodule ExLearn.NeuralNetwork.ForwarderTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Forwarder

  setup do
    f = fn (x, _all) -> x + 1 end
    d = fn (_all)    -> 1     end

    objective    = fn(x, y) -> Matrix.substract(y, x) |> Matrix.sum end
    presentation = fn(x)    -> x end

    state = %{
      network: %{
        layers: [
          %{},
          %{
            activity: %{function: f, derivative: d},
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            activity: %{function: f, derivative: d},
            biases:   Matrix.new(1, 2, [[4, 5]]),
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            activity: %{function: f, derivative: d},
            biases:   Matrix.new(2, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          }
        ],
        objective:    %{function: objective},
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
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 3, [[31, 38, 45]]),
          output:     Matrix.new(1, 3, [[32, 39, 46]])
        },
        %{
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[383, 501]]),
          output:     Matrix.new(1, 2, [[384, 502]])
        },
        %{
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
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 3, [[43, 53, 63]]),
          output:     Matrix.new(1, 3, [[44, 54, 64]])
        },
        %{
          function:   function,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[530, 693]]),
          output:     Matrix.new(1, 2, [[531, 694]])
        },
        %{
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

    first_input  = {1, Matrix.new(1, 3, [[1, 2, 3]])}
    second_input = {2, Matrix.new(1, 3, [[2, 3, 4]])}

    first_expected  = {1, Matrix.new(1, 2, [[1897, 2784]])}
    second_expected = {2, Matrix.new(1, 2, [[2620, 3846]])}

    assert Forwarder.forward_for_output(first_input,  state) == first_expected
    assert Forwarder.forward_for_output(second_input, state) == second_expected
  end

  test "#forward_for_test returns the error and match", %{setup: setup} do
    %{state: state} = setup

    first_input  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_input = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    first_expected  = {-19, false}
    second_expected = { 66, false}

    assert Forwarder.forward_for_test(first_input,  state) == first_expected
    assert Forwarder.forward_for_test(second_input, state) == second_expected
  end
end
