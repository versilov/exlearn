defmodule ExLearn.NeuralNetwork.WorkerFixtures do
  alias ExLearn.Matrix

  def initial_network_state do
    function     = fn(x, _all)  -> x + 1                  end
    derivative   = fn(_x, _all) -> 1                      end
    objective    = fn(a, b, _c) -> Matrix.substract(b, a) end
    presentation = fn(x)        -> x                      end

    %{
      network: %{
        layers: [
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
            biases:   Matrix.new(1, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          },
        ],
        objective:    %{error: objective},
        presentation: presentation
      }
    }
  end
end
