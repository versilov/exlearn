defmodule ExLearn.NeuralNetwork.AccumulatorFixtures do
  alias ExLearn.Matrix

  def network_state_functions do
    function     = fn(x,  _all) -> x + 1                  end
    derivative   = fn(_x, _all) -> 1                      end
    objective    = fn(a, b, _c) -> Matrix.substract(b, a) end
    presentation = fn(x)        -> x                      end

    %{
      function:     function,
      derivative:   derivative,
      objective:    objective,
      presentation: presentation
    }
  end

  def initial_network_state do
    %{
      function:     function,
      derivative:   derivative,
      objective:    objective,
      presentation: presentation
    } = network_state_functions()

    %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[4, 5]]),
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          },
        ],
        objective:    %{error: objective},
        presentation: presentation
      }
    }
  end

  def expected_network_state do
    %{
      function:     function,
      derivative:   derivative,
      objective:    objective,
      presentation: presentation
    } = network_state_functions()

    %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 3, [[-837, -1828, -2819]]),
            weights:  Matrix.new(3, 3, [
              [-2037, -4452, -6867 ],
              [-2872, -6279, -9686 ],
              [-3707, -8106, -12505]
            ])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[-150, -337]]),
            weights:  Matrix.new(3, 2, [
              [-7615,  -16798],
              [-9363,  -20654],
              [-11111, -24510]
            ])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[-28, -53]]),
            weights:  Matrix.new(2, 2, [
              [-18935, -36562],
              [-24745, -47780]
            ])
          }
        ],
        objective:    %{error: objective},
        presentation: presentation
      }
    }
  end

  def expected_network_states_for_l1 do
    %{
      function:     function,
      derivative:   derivative,
      objective:    objective,
      presentation: presentation
    } = network_state_functions()

    %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 3, [[-837, -1828, -2819]]),
            weights:  Matrix.new(3, 3, [
              [-2041, -4456, -6871 ],
              [-2876, -6283, -9690 ],
              [-3711, -8110, -12509]
            ])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[-150, -337]]),
            weights:  Matrix.new(3, 2, [
              [-7619,  -16802],
              [-9367,  -20658],
              [-11115, -24514]
            ])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[-28, -53]]),
            weights:  Matrix.new(2, 2, [
              [-18939, -36566],
              [-24749, -47784]
            ])
          }
        ],
        objective:    %{error: objective},
        presentation: presentation
      }
    }
  end

  def expected_network_states_for_l2 do
    %{
      function:     function,
      derivative:   derivative,
      objective:    objective,
      presentation: presentation
    } = network_state_functions()

    %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 3, [[-837, -1828, -2819]]),
            weights:  Matrix.new(3, 3, [
              [-2041, -4460, -6879 ],
              [-2888, -6299, -9710 ],
              [-3735, -8138, -12541]
            ])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[-150, -337]]),
            weights:  Matrix.new(3, 2, [
              [-7619,  -16806],
              [-9375,  -20670],
              [-11131, -24534]
            ])
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   Matrix.new(1, 2, [[-28, -53]]),
            weights:  Matrix.new(2, 2, [
              [-18939, -36570],
              [-24757, -47796]
            ])
          }
        ],
        objective:    %{error: objective},
        presentation: presentation
      }
    }
  end
end
