defmodule PropagatorTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Propagator

  setup do
    derivative = fn(_)    -> 1 end
    objective  = fn(a, b, _c) ->
      Stream.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    configuration = %{
      batch_size:    1,
      learning_rate: 2
    }

    network_state = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
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
        [[419, 915, 1411]],
        [[77,  171]],
        [[17,  30]]
      ],
      [
        [
          [1019, 2227, 3435],
          [1438, 3142, 4846],
          [1857, 4057, 6257]
        ],
        [
          [3808, 8400 ],
          [4683, 10329],
          [5558, 12258]
        ],
        [
          [9468,  18282],
          [12374, 23892]
        ]
      ]
    }

    expected = %{
      network: %{
        layers: [
          %{
            activity: %{derivative: derivative},
            biases:   [[-837, -1828, -2819]],
            weights:  [
              [-2037, -4452, -6867 ],
              [-2872, -6279, -9686 ],
              [-3707, -8106, -12505]
            ]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[-150, -337]],
            weights:  [
              [-7615,  -16798],
              [-9363,  -20654],
              [-11111, -24510]
            ]
          },
          %{
            activity: %{derivative: derivative},
            biases:   [[-28, -53]],
            weights:  [
              [-18935, -36562],
              [-24745, -47780]
            ]
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
      configuration: configuration,
      derivative:    derivative,
      network_state: network_state,
    } = setup

    first_forward_state = %{
      activity: [
        %{
          arity:      1,
          derivative: derivative,
          input:      [[31, 38, 45]],
          output:     [[32, 39, 46]]
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      [[383, 501]],
          output:     [[384, 502]]
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      [[1896, 2783]],
          output:     [[1897, 2784]]
        }
      ],
      expected: [1900, 2800],
      input:    [1, 2, 3],
      output:   [1897, 2784]
    }

    first_correction = {
      [
        [[-181, -397, -613]],
        [[-35,  -73]],
        [[-3,   -16]]
      ],
      [
        [
          [-181, -397,  -613 ],
          [-362, -794,  -1226],
          [-543, -1191, -1839]
        ],
        [
          [-1120, -2336],
          [-1365, -2847],
          [-1610, -3358]
        ],
        [
          [-1152, -6144],
          [-1506, -8032]
        ]
      ]
    }

    second_forward_state = %{
      activity: [
        %{
          arity:      1,
          derivative: derivative,
          input:      [[43, 53, 63]],
          output:     [[44, 54, 64]]
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      [[530, 693]],
          output:     [[531, 694]]
        },
        %{
          arity:      1,
          derivative: derivative,
          input:      [[2619, 3845]],
          output:     [[2620, 3846]]
        }
      ],
      expected: [2600, 3800],
      input:    [2, 3, 4],
      output:   [2620, 3846]
    }

    second_correction = {
      [
        [[600, 1312, 2024]],
        [[112, 244]],
        [[20,  46]]
      ],
      [
        [
          [1200, 2624, 4048],
          [1800, 3936, 6072],
          [2400, 5248, 8096]
        ],
        [
          [4928, 10736],
          [6048, 13176],
          [7168, 15616]
        ],
        [
          [10620, 24426],
          [13880, 31924]
        ]
      ]
    }

    assert Propagator.back_propagate(
      first_forward_state,
      configuration,
      network_state
    ) == first_correction

    assert Propagator.back_propagate(
      second_forward_state,
      configuration,
      network_state
    ) == second_correction
  end
end
