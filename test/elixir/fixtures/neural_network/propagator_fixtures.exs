defmodule ExLearn.NeuralNetwork.PropagatorFixtures do
  alias ExLearn.Matrix

  def network_functions do
    derivative     = fn(_x, _all) -> 1                      end
    objective      = fn(a, b, _c) -> Matrix.substract(b, a) end

    %{
      derivative: derivative,
      objective:  objective,
    }
  end

  def network_state do
    %{
      derivative: derivative,
      objective:  objective,
    } = network_functions()

    %{
      network: %{
        layers: [
          %{},
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
  end

  def configuration do
    regularization = fn(x, _, _)  -> x end

    %{
      batch_size:     1,
      data_size:      1,
      learning_rate:  2,
      workers:        1,
      regularization: regularization
    }
  end

  def configuration_with_regularization do
    regularization = fn(x, _, _)  -> x + 1 end

    %{
      batch_size:     1,
      data_size:      1,
      learning_rate:  2,
      workers:        1,
      regularization: regularization
    }
  end

  def configuration_with_momentum do
    Map.put(configuration(), :momentum, 0.5)
  end

  def network_state_with_mask do
    %{
      derivative: derivative,
      objective:  objective,
    } = network_functions()

    %{
      network: %{
        layers: [
          %{},
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
  end

  def correction do
    {
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
  end

  def expected_from_correction do
    %{
      derivative: derivative,
      objective:  objective,
    } = network_functions()

    %{
      network: %{
        layers: [
          %{},
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 3, [[-837, -1828, -2819]]),
            weights:  Matrix.new(3, 3, [
              [-2037, -4452, -6867 ],
              [-2872, -6279, -9686 ],
              [-3707, -8106, -12505]
            ])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[-150, -337]]),
            weights:  Matrix.new(3, 2, [
              [-7615,  -16798],
              [-9363,  -20654],
              [-11111, -24510]
            ])
          },
          %{
            activity: %{derivative: derivative},
            biases:   Matrix.new(1, 2, [[-28, -53]]),
            weights:  Matrix.new(2, 2, [
              [-18935, -36562],
              [-24745, -47780]
            ])
          }
        ],
        objective: %{error: objective}
      }
    }
  end

  def expected_from_correction_with_regularization do
    %{
      derivative: derivative,
      objective:  objective,
    } = network_functions()

    %{
      network: %{
        layers: [
          %{},
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
  end

  def first_forward_state do
    %{derivative: derivative} = network_functions()

    %{
      activity: [
        %{
          output: Matrix.new(1, 3, [[1, 2, 3]])
        },
        %{
          derivative: derivative,
          input:      Matrix.new(1, 3, [[31, 38, 45]]),
          output:     Matrix.new(1, 3, [[32, 39, 46]])
        },
        %{
          derivative: derivative,
          input:      Matrix.new(1, 2, [[383, 501]]),
          output:     Matrix.new(1, 2, [[384, 502]])
        },
        %{
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

  def first_correction do
    {
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
  end

  def second_forward_state do
    %{derivative: derivative} = network_functions()

    %{
      activity: [
        %{
          output: Matrix.new(1, 3, [[2, 3, 4]])
        },
        %{
          derivative: derivative,
          input:      Matrix.new(1, 3, [[43, 53, 63]]),
          output:     Matrix.new(1, 3, [[44, 54, 64]])
        },
        %{
          derivative: derivative,
          input:      Matrix.new(1, 2, [[530, 693]]),
          output:     Matrix.new(1, 2, [[531, 694]])
        },
        %{
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

  def second_correction do
    {
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
  end

  def forward_state_with_mask do
    %{derivative: derivative} = network_functions()

    %{
      activity: [
        %{
          mask:   Matrix.new(1, 3, [[1, 1, 1]]),
          output: Matrix.new(1, 3, [[1, 2, 3]])
        },
        %{
          derivative: derivative,
          input:      Matrix.new(1, 3, [[31, 38, 45]]),
          output:     Matrix.new(1, 3, [[32, 39, 46]]),
          mask:       Matrix.new(1, 3, [[1,  1,  1 ]]),
        },
        %{
          derivative: derivative,
          input:      Matrix.new(1, 2, [[383, 501]]),
          output:     Matrix.new(1, 2, [[384, 502]]),
          mask:       Matrix.new(1, 3, [[1,  1,  1 ]]),
        },
        %{
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
end
