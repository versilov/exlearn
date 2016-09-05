[
  "test/test_util.exs",
  "test/fixtures/data_fixtures.exs",
  "test/fixtures/neural_network/worker_fixtures.exs"
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Worker.TrainTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil
  alias ExLearn.DataFixtures
  alias ExLearn.NeuralNetwork.WorkerFixtures

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:    name,
      options: options
    }}
  end

  test "#train with data in file returns the correction", %{setup: setup} do
    %{name: worker = {:global, reference}, options: options} = setup

    data          = DataFixtures.first_sample
    network_state = WorkerFixtures.initial_network_state

    path = TestUtil.temp_file_path("exlearn-neural_network-worker-train_test")
    :ok  = File.write(path, data)

    args = %{
      configuration: %{
        batch_size:    1,
        learning_rate: 2
      },
      data: %{location: :file, source: [path]}
    }

    {:ok, worker_pid} = Worker.start_link(args, options)
    assert Worker.get(worker) == :no_data

    Worker.train(network_state, worker)
    {:done, correction} = Worker.get(worker)

    expected_correction = {
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

    assert correction         == expected_correction
    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#train with data in memory returns the correction", %{setup: setup} do
    %{name: worker = {:global, reference}, options: options} = setup

    data = [{Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}]
    network_state = WorkerFixtures.initial_network_state

    args = %{
      configuration: %{
        batch_size:    1,
        learning_rate: 2
      },
      data: %{location: :memory, source: data}
    }

    {:ok, worker_pid} = Worker.start_link(args, options)
    assert Worker.get(worker) == :no_data

    Worker.train(network_state, worker)
    {:done, correction} = Worker.get(worker)

    expected_correction = {
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

    assert correction == expected_correction

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
