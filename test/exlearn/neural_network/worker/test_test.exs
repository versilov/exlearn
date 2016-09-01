[
  "test/test_util.exs",
  "test/fixtures/data_fixtures.exs",
  "test/fixtures/neural_network/worker_fixtures.exs"
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Worker.TestTest do
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

  test "#test with data in file returns the prediction", %{setup: setup} do
    %{name: worker, options: options} = setup

    data          = DataFixtures.both_samples
    expected      = {47.0, 0}
    network_state = WorkerFixtures.initial_network_state

    path = TestUtil.temp_file_path("exlearn-neural_network-worker-test_test")
    :ok  = File.write(path, data)

    args = %{data: %{location: :file, source: [path]}}

    {:ok, _pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data
    Worker.test(network_state, worker)
    assert Worker.get(worker) == expected

    :ok = File.rm(path)
  end

  test "#test with data in memory returns the prediction", %{setup: setup} do
    %{
      name:    worker,
      options: options
    } = setup

    first_sample  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_sample = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    data          = [first_sample, second_sample]
    expected      = {47.0, 0}
    network_state = WorkerFixtures.initial_network_state

    args = %{data: %{location: :memory, source: data}}

    {:ok, _pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data
    Worker.test(network_state, worker)
    assert Worker.get(worker) == expected
  end
end
