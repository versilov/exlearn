defmodule ExLearn.NeuralNetwork.ForwarderFixtures do
  alias ExLearn.Matrix

  def network_functions do
    function   = fn (x, _all) -> x + 1 end
    derivative = fn (_all)    -> 1     end

    objective    = fn(x, y) -> Matrix.substract(y, x) |> Matrix.sum end
    presentation = fn(x)    -> x end

    %{
      derivative:   derivative,
      function:     function,
      objective:    objective,
      presentation: presentation
    }
  end

  def network_state do
    %{
      derivative:   derivative,
      function:     function,
      objective:    objective,
      presentation: presentation
    } = network_functions()

    %{
      network: %{
        layers: [
          %{},
          %{
            activity: %{function: function, derivative: derivative},
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            activity: %{function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[4, 5]]),
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            activity: %{function: function, derivative: derivative},
            biases:   Matrix.new(2, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          }
        ],
        objective:    %{function: objective},
        presentation: presentation
      }
    }
  end

  def network_state_with_dropout do
    %{
      derivative:   derivative,
      function:     function,
      objective:    objective,
      presentation: presentation
    } = network_functions()

    %{
      network: %{
        layers: [
          %{dropout: 0.2, size: 3},
          %{
            activity: %{function: function, derivative: derivative},
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            columns:  3,
            dropout:  0.5,
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            activity: %{function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[4, 5]]),
            columns:  2,
            dropout:  0.5,
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            activity: %{function: function, derivative: derivative},
            biases:   Matrix.new(2, 2, [[6, 7]]),
            columns:  2,
            dropout:  0.5,
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          }
        ],
        objective:    %{function: objective},
        presentation: presentation
      }
    }
  end

  def first_activity do
    %{
      derivative:   derivative,
      function:     function
    } = network_functions()

    %{
      activity: [
        %{
          output: Matrix.new(1, 3, [[1, 2, 3]])
        },
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
  end

  def second_activity do
    %{
      derivative:   derivative,
      function:     function
    } = network_functions()

    %{
      activity: [
        %{
          output: Matrix.new(1, 3, [[2, 3, 4]])
        },
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
  end
end
