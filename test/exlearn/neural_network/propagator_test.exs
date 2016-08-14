defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Propagator

  setup do
    derivative = fn(_)    -> 1 end
    objective  = fn(a, b, _c) ->
      Enum.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end
    regularization = fn(x, _, _) -> x + 1 end

    configuration = %{
      batch_size:     1,
      data_size:      1,
      learning_rate:  2,
      workers:        1,
      regularization: regularization
    }

    network_state = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[4, 5]]),
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          }
        ],
        objective: %{error: objective}
      }
    }

    {:ok, setup: %{
      configuration: configuration,
      derivative:    derivative,
      network_state: network_state,
      objective:     objective
    }}
  end

  test "#apply_changes returns the new state", %{setup: setup} do
    %{
      configuration: configuration,
      derivative:    derivative,
      network_state: network_state,
      objective:     objective
    } = setup

    correction = {
      [
        Matrix.new(1, 3, [[419, 915, 1411]]),
        Matrix.new(1, 2, [[77,  171]]      ),
        Matrix.new(1, 2, [[17,  30]]       )
      ],
      [
        Matrix.new(3, 3, [
          [1019, 2227, 3435],
          [1438, 3142, 4846],
          [1857, 4057, 6257]
        ]),
        Matrix.new(3, 2, [
          [3808, 8400 ],
          [4683, 10329],
          [5558, 12258]
        ]),
        Matrix.new(2, 2, [
          [9468,  18282],
          [12374, 23892]
        ])
      ]
    }

    expected = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 3, [[-837, -1828, -2819]]),
            weights:  Matrix.new(3, 3, [
              [-2036, -4451, -6866 ],
              [-2871, -6278, -9685 ],
              [-3706, -8105, -12504]
            ])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[-150, -337]]),
            weights:  Matrix.new(3, 2, [
              [-7614,  -16797],
              [-9362,  -20653],
              [-11110, -24509]
            ])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[-28, -53]]),
            weights:  Matrix.new(2, 2, [
              [-18934, -36561],
              [-24744, -47779]
            ])
          }
        ],
        objective: %{error: objective}
      }
    }

    assert Propagator.apply_changes(
      correction,
      configuration,
      network_state
    ) == expected
  end

  test "#apply_changes with regularization returns the new state", %{setup: setup} do
    %{
      configuration: configuration,
      derivative:    derivative,
      network_state: network_state,
      objective:     objective
    } = setup

    correction = {
      [
        Matrix.new(1, 3, [[419, 915, 1411]]),
        Matrix.new(1, 2, [[77,  171]]      ),
        Matrix.new(1, 2, [[17,  30]]       )
      ],
      [
        Matrix.new(3, 3, [
          [1019, 2227, 3435],
          [1438, 3142, 4846],
          [1857, 4057, 6257]
        ]),
        Matrix.new(3, 2, [
          [3808, 8400 ],
          [4683, 10329],
          [5558, 12258]
        ]),
        Matrix.new(2, 2, [
          [9468,  18282],
          [12374, 23892]
        ])
      ]
    }

    expected = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 3, [[-837, -1828, -2819]]),
            weights:  Matrix.new(3, 3, [
              [-2036, -4451, -6866 ],
              [-2871, -6278, -9685 ],
              [-3706, -8105, -12504]
            ])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[-150, -337]]),
            weights:  Matrix.new(3, 2, [
              [-7614,  -16797],
              [-9362,  -20653],
              [-11110, -24509]
            ])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[-28, -53]]),
            weights:  Matrix.new(2, 2, [
              [-18934, -36561],
              [-24744, -47779]
            ])
          }
        ],
        objective: %{error: objective}
      }
    }

    assert Propagator.apply_changes(
      correction,
      configuration,
      network_state
    ) == expected
  end

  test "#back_propagate returns the correction", %{setup: setup} do
    %{
      derivative:    derivative,
      network_state: network_state,
    } = setup

    first_forward_state = %{
      activity: [
        %{
          arity:      1,
          derivative: derivative,
          input:      Matrix.new(1, 3, [[31, 38, 45]]),
          output:     Matrix.new(1, 3, [[32, 39, 46]])
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[383, 501]]),
          output:     Matrix.new(1, 2, [[384, 502]])
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[1896, 2783]]),
          output:     Matrix.new(1, 2, [[1897, 2784]])
        }
      ],
      expected: Matrix.new(1, 2, [[1900, 2800]]),
      input:    Matrix.new(1, 3, [[1, 2, 3]]),
      output:   Matrix.new(1, 2, [[1897, 2784]])
    }

    first_correction = {
      [
        Matrix.new(1, 3, [[-181, -397, -613]]),
        Matrix.new(1, 2, [[-35,  -73]]       ),
        Matrix.new(1, 2, [[-3,   -16]]       )
      ],
      [
        Matrix.new(3, 3, [
          [-181, -397,  -613 ],
          [-362, -794,  -1226],
          [-543, -1191, -1839]
        ]),
        Matrix.new(3, 2, [
          [-1120, -2336],
          [-1365, -2847],
          [-1610, -3358]
        ]),
        Matrix.new(2, 2, [
          [-1152, -6144],
          [-1506, -8032]
        ])
      ]
    }

    second_forward_state = %{
      activity: [
        %{
          arity:      1,
          derivative: derivative,
          input:      Matrix.new(1, 3, [[43, 53, 63]]),
          output:     Matrix.new(1, 3, [[44, 54, 64]])
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[530, 693]]),
          output:     Matrix.new(1, 2, [[531, 694]])
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      Matrix.new(1, 2, [[2619, 3845]]),
          output:     Matrix.new(1, 2, [[2620, 3846]])
        }
      ],
      expected: Matrix.new(1, 2, [[2600, 3800]]),
      input:    Matrix.new(1, 3, [[2, 3, 4]]),
      output:   Matrix.new(1, 2, [[2620, 3846]])
    }

    second_correction = {
      [
        Matrix.new(1, 3, [[600, 1312, 2024]]),
        Matrix.new(1, 2, [[112, 244]]       ),
        Matrix.new(1, 2, [[20,  46]]        )
      ],
      [
        Matrix.new(3, 3, [
          [1200, 2624, 4048],
          [1800, 3936, 6072],
          [2400, 5248, 8096]
        ]),
        Matrix.new(3, 2, [
          [4928, 10736],
          [6048, 13176],
          [7168, 15616]
        ]),
        Matrix.new(2, 2, [
          [10620, 24426],
          [13880, 31924]
        ])
      ]
    }

    assert Propagator.back_propagate(
      first_forward_state,
      network_state
    ) == first_correction

    assert Propagator.back_propagate(
      second_forward_state,
      network_state
    ) == second_correction
  end
end
