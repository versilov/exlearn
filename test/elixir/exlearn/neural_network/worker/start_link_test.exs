Code.require_file("test/elixir/test_util.exs")
Code.require_file("test/elixir/fixtures/data_fixtures.exs")

defmodule ExLearn.NeuralNetwork.Worker.StartLinkTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil
  alias ExLearn.DataFixtures

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:    name,
      options: options,
    }}
  end

  test "#start_link with data in one file returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    data = DataFixtures.both_samples
    path = TestUtil.temp_file_path("neural_network-worker-start_test")
    :ok  = File.write(path, data)

    args = %{data: %{location: :file, source: [path]}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#start_link with data in two files returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    first_data  = DataFixtures.first_sample
    second_data = DataFixtures.second_sample

    first_path  = TestUtil.temp_file_path("neural_network-worker-start_test-1")
    second_path = TestUtil.temp_file_path("neural_network-worker-start_test-2")

    :ok  = File.write(first_path,  first_data )
    :ok  = File.write(second_path, second_data)

    args = %{data: %{location: :file, source: [first_path, second_path]}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(first_path )
    :ok = File.rm(second_path)
  end

  test "#start_link with data in memory returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    data = [
      {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])},
      {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    ]

    args = %{data: %{location: :memory, source: data}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
