defmodule ExLearn.NeuralNetwork.WorkerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  setup do
    function   = fn(x)    -> x + 1 end
    derivative = fn(_)    -> 1     end
    objective  = fn(a, b, _c) ->
      Enum.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    configuration = %{batch_size: 1, learning_rate: 2}
    data          = [{[1, 2, 3], [1900, 2800]}, {[2, 3, 4], [2600, 3800]}]
    network_state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
        ],
        objective: %{error: objective}
      }
    }

    name    = {:global, make_ref()}
    args    = {data, configuration}
    options = [name: name]

    {:ok, setup: %{
      args:          args,
      configuration: configuration,
      data:          data,
      name:          name,
      network_state: network_state,
      options:       options
    }}
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, worker_pid} = Worker.start(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#prepare can be called successfully", %{setup: setup} do
    %{
      args:    args,
      name:    worker = {:global, reference},
      options: options
    } = setup

    {:ok, worker_pid} = Worker.start_link(args, options)
    pid_of_reference  = :global.whereis_name(reference)

    assert Worker.prepare(worker) == :ok

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#work|:train returns the correction", %{setup: setup} do
    %{
      args:          args,
      name:          worker = {:global, reference},
      network_state: network_state,
      options:       options
    } = setup

    {:ok, worker_pid} = Worker.start_link(args, options)
    :ok               = Worker.prepare(worker)

    {:continue, first_correction } = Worker.work(:train, network_state, worker)
    {:done,     second_correction} = Worker.work(:train, network_state, worker)

    first_expected_correction = {
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

    second_expected_correction = {
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

    assert first_correction  == first_expected_correction
    assert second_correction == second_expected_correction

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
