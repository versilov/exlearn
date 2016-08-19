defmodule ExLearn.NeuralNetwork.Worker.StartLinkTest do
  use ExUnit.Case, async: true

  alias ExLearn.{Matrix, TestUtils}
  alias ExLearn.NeuralNetwork.Worker

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:    name,
      options: options,
    }}
  end

  test "#start_link with no data returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = []
    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  test "#start_link with empty file list returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      options: options
    } = setup

    args = %{
      data:          %{location: :file, source: []},
      configuration: %{}
    }

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

    args = %{
      data:          %{location: :memory, source: []},
      configuration: %{}
    }

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
    path = TestUtils.temp_file_path("neural_network-worker-start_test")
    TestUtils.write_to_file_as_binary(data, path)

    args = %{
      data:          %{location: :file, source: [path]},
      configuration: %{}
    }

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

    data = [
      {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])},
      {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    ]
    path = TestUtils.temp_file_path("neural_network-worker-start_test")
    TestUtils.write_to_file_as_binary(data, path)

    args = %{
      data:          %{location: :file, source: [path]},
      configuration: %{}
    }

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

    first_data  = [{Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}]
    second_data = [{Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}]

    first_path  = TestUtils.temp_file_path("neural_network-worker-start_test-1")
    second_path = TestUtils.temp_file_path("neural_network-worker-start_test-2")

    TestUtils.write_to_file_as_binary(first_data,  first_path )
    TestUtils.write_to_file_as_binary(second_data, second_path)

    args = %{
      data:          %{location: :file, source: [first_path, second_path]},
      configuration: %{}
    }

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

    first_path  = TestUtils.temp_file_path("neural_network-worker-start_test-1")
    second_path = TestUtils.temp_file_path("neural_network-worker-start_test-2")

    TestUtils.write_to_file_as_binary(first_data,  first_path )
    TestUtils.write_to_file_as_binary(second_data, second_path)

    args = %{
      data:          %{location: :file, source: [first_path, second_path]},
      configuration: %{}
    }

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

    first_path  = TestUtils.temp_file_path("neural_network-worker-start_test-1")
    second_path = TestUtils.temp_file_path("neural_network-worker-start_test-2")

    TestUtils.write_to_file_as_binary(first_data,  first_path )
    TestUtils.write_to_file_as_binary(second_data, second_path)

    args = %{
      data:          %{location: :file, source: [first_path, second_path]},
      configuration: %{}
    }

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

    args = %{
      data:          %{location: :memory, source: data},
      configuration: %{}
    }

    {:ok, worker_pid} = Worker.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
