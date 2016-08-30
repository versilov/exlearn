Code.require_file("test/test_util.exs")

defmodule ExLearn.NeuralNetwork.Worker.StartLinkTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:    name,
      options: options,
    }}
  end

  test "#start_link with empty file list returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = %{data: %{location: :file, source: []}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#start_link with empty data list returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = %{data: %{location: :memory, source: []}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#start_link with empty data in one file returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    data = []
    path = TestUtil.temp_file_path("neural_network-worker-start_test")
    TestUtil.write_to_file_as_binary(data, path)

    args = %{data: %{location: :file, source: [path]}}

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#start_link with data in one file returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    data = <<
      1 :: float-little-32, # version
      2 :: float-little-32, # number of elements
      5 :: float-little-32, # length of input
      4 :: float-little-32, # length of label
      1 :: float-little-32  # length of step
    >>
    <> Matrix.new(1, 3, [[1, 2, 3]]) <> Matrix.new(1, 2, [[1900, 2800]])
    <> Matrix.new(1, 3, [[2, 3, 4]]) <> Matrix.new(1, 2, [[2600, 3800]])

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

    first_data = <<
      1 :: float-little-32, # version
      1 :: float-little-32, # number of elements
      5 :: float-little-32, # length of input
      4 :: float-little-32, # length of label
      1 :: float-little-32  # length of step
    >>
    <> Matrix.new(1, 3, [[1, 2, 3]]) <> Matrix.new(1, 2, [[1900, 2800]])

    second_data = <<
      1 :: float-little-32, # version
      1 :: float-little-32, # number of elements
      5 :: float-little-32, # length of input
      4 :: float-little-32, # length of label
      1 :: float-little-32  # length of step
    >>
    <> Matrix.new(1, 3, [[2, 3, 4]]) <> Matrix.new(1, 2, [[2600, 3800]])

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

  test "#start_link with data in two files with one empty returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    first_data  = [{Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}]
    second_data = []

    first_path  = TestUtil.temp_file_path("neural_network-worker-start_test-1")
    second_path = TestUtil.temp_file_path("neural_network-worker-start_test-2")

    TestUtil.write_to_file_as_binary(first_data,  first_path )
    TestUtil.write_to_file_as_binary(second_data, second_path)

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

  test "#start_link with data in two files with both empty returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    first_data  = []
    second_data = []

    first_path  = TestUtil.temp_file_path("neural_network-worker-start_test-1")
    second_path = TestUtil.temp_file_path("neural_network-worker-start_test-2")

    TestUtil.write_to_file_as_binary(first_data,  first_path )
    TestUtil.write_to_file_as_binary(second_data, second_path)

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
