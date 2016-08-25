Code.require_file("test/test_util.exs")
Code.require_file("test/fixtures/neural_network/worker_fixtures.exs")

defmodule ExLearn.NeuralNetwork.Worker.TestTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil
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

    first_sample  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_sample = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    data          = [first_sample, second_sample]
    expected      = {47.0, 0}
    network_state = WorkerFixtures.initial_network_state
    path          = TestUtil.temp_file_path()

    TestUtil.write_to_file_as_binary(data, path)

    args = %{data: %{location: :file, source: [path]}}

    {:ok, _pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data

    :ok    = Worker.test(network_state, worker)
    result = Worker.get(worker)

    assert result == expected

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

    :ok    = Worker.test(network_state, worker)
    result = Worker.get(worker)

    assert result == expected
  end

  test "#test with no data from file can be called", %{setup: setup} do
    %{name: worker = {:global, reference}, options: options} = setup

    network_state = WorkerFixtures.initial_network_state

    data = []
    path = TestUtil.temp_file_path()
    TestUtil.write_to_file_as_binary(data, path)

    args = %{data: %{location: :file, source: [path]}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data

    Worker.test(network_state, worker)

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#test with no data from memory can be called", %{setup: setup} do
    %{name: worker = {:global, reference}, options: options} = setup

    network_state = WorkerFixtures.initial_network_state

    args = %{data: %{location: :file, source: []}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data

    Worker.test(network_state, worker)

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
