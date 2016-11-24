Code.require_file("test/elixir/test_util.exs")

defmodule ExLearn.NeuralNetworkTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork
  alias ExLearn.NeuralNetwork.Notification

  alias ExLearn.TestUtil

  setup do
    structure_parameters = %{
      layers: %{
        input:   %{size: 1},
        hidden: [%{activity: :identity, name: "First Hidden", size: 1}],
        output:  %{activity: :identity, name: "Output",       size: 1}
      },
      objective: :quadratic
    }

    network = NeuralNetwork.create(structure_parameters)

    initialization_parameters = %{
      distribution: :uniform,
      maximum:       1,
      minimum:      -1,
    }

    NeuralNetwork.initialize(network, initialization_parameters)

    training_data = [
      {Matrix.new(1, 1, [[0]]), Matrix.new(1, 1, [[0]])},
      {Matrix.new(1, 1, [[1]]), Matrix.new(1, 1, [[1]])},
      {Matrix.new(1, 1, [[2]]), Matrix.new(1, 1, [[2]])},
      {Matrix.new(1, 1, [[3]]), Matrix.new(1, 1, [[3]])},
      {Matrix.new(1, 1, [[4]]), Matrix.new(1, 1, [[4]])},
      {Matrix.new(1, 1, [[5]]), Matrix.new(1, 1, [[5]])}
    ]

    validation_data = [
      {Matrix.new(1, 1, [[6]]), Matrix.new(1, 1, [[6]])},
      {Matrix.new(1, 1, [[7]]), Matrix.new(1, 1, [[7]])}
    ]

    test_data = [
      {Matrix.new(1, 1, [[8]]), Matrix.new(1, 1, [[8]])},
      {Matrix.new(1, 1, [[9]]), Matrix.new(1, 1, [[9]])}
    ]

    predict_data = [
      {0, Matrix.new(1, 1, [[0]])},
      {1, Matrix.new(1, 1, [[1]])},
      {2, Matrix.new(1, 1, [[2]])},
      {3, Matrix.new(1, 1, [[3]])},
      {4, Matrix.new(1, 1, [[4]])},
      {5, Matrix.new(1, 1, [[5]])}
    ]

    data = %{
      train:    %{data: training_data,   size: 6},
      validate: %{data: validation_data, size: 2},
      test:     %{data: test_data,       size: 2},
      predict:  %{data: predict_data,    size: 6}
    }

    parameters = %{
      batch_size:    4,
      epochs:        5,
      learning_rate: 0.05,
      workers:       2
    }

    {:ok, setup: %{
      data:       data,
      parameters: parameters,
      network:    network
    }}
  end

  test "#initialize returns a running process tree", %{setup: setup} do
    %{network: %{
      accumulator:  {:global, accumulator_reference },
      manager:      {:global, manager_reference     },
      master:       {:global, master_reference      },
      notification: {:global, notification_reference},
      store:        {:global, store_reference       }
    }} = setup

    pid_of_accumulator  = :global.whereis_name(accumulator_reference)
    pid_of_manager      = :global.whereis_name(manager_reference)
    pid_of_master       = :global.whereis_name(master_reference)
    pid_of_notification = :global.whereis_name(notification_reference)
    pid_of_store        = :global.whereis_name(store_reference)

    assert accumulator_reference  |> is_reference
    assert manager_reference      |> is_reference
    assert master_reference       |> is_reference
    assert notification_reference |> is_reference
    assert store_reference        |> is_reference

    assert pid_of_accumulator  |> Process.alive?
    assert pid_of_manager      |> Process.alive?
    assert pid_of_master       |> Process.alive?
    assert pid_of_notification |> Process.alive?
    assert pid_of_store        |> Process.alive?
  end

  test "#load responds with :ok", %{setup: setup} do
    %{network: network} = setup

    path     = TestUtil.temp_file_path("exlearn-neural_network_test")
    ^network = NeuralNetwork.save(network, path)

    assert NeuralNetwork.load(network, path) == network

    :ok = File.rm(path)
  end

  test "#notifications outputs to stdout", %{setup: setup} do
    %{network: network} = setup

    :ok = Notification.push("Message 1", network)

    assert capture_io(fn ->
      NeuralNetwork.notifications(network, :start)
      :ok = Notification.push("Message 2", network)
      NeuralNetwork.notifications(network, :stop)
    end) == "Message 1\nMessage 2\n"
  end

  test "#notifications stops the outputing process when done", %{setup: setup} do
    %{network: network} = setup

    :ok = Notification.push("Message 1", network)

    assert capture_io(fn ->
      ^network = NeuralNetwork.notifications(network, :start)

      :ok = Notification.push("Message 2", network)
      NeuralNetwork.notifications(network, :stop)

    end) == "Message 1\nMessage 2\n"
  end

  test "#predict responds with a list of numbers", %{setup: setup} do
    %{data: data, network: network} = setup

    result = NeuralNetwork.predict(network, data)
    |> NeuralNetwork.result

    assert result |> is_list

    Enum.each(result, fn({_id, output}) ->
      assert output |> is_binary
    end)
  end

  test "#predict with parameters responds with a list of numbers", %{setup: setup} do
    %{data: data, parameters: parameters, network: network} = setup

    result = NeuralNetwork.predict(network, data, parameters)
    |> NeuralNetwork.result

    assert result |> is_list

    Enum.each(result, fn({_id, output}) ->
      assert output |> is_binary
    end)
  end

  test "#process responds with a list of numbers", %{setup: setup} do
    %{data: data, parameters: parameters, network: network} = setup

    result = NeuralNetwork.process(network, data, parameters)
    |> NeuralNetwork.result

    assert result |> is_list

    Enum.each(result, fn({_id, output}) ->
      assert output |> is_binary
    end)
  end

  test "#save responds with :ok", %{setup: setup} do
    %{network: network} = setup

    path = TestUtil.temp_file_path("exlearn-neural_network_test")

    assert NeuralNetwork.save(network, path) == network

    :ok = File.rm(path)
  end

  test "#test responds with :ok", %{setup: setup} do
    %{data: data, parameters: parameters, network: network} = setup

    result = NeuralNetwork.test(network, data, parameters)
    |> NeuralNetwork.result

    assert result == :no_data
  end

  test "#train responds with :ok", %{setup: setup} do
    %{data: data, parameters: parameters, network: network} = setup

    result = NeuralNetwork.train(network, data, parameters)
    |> NeuralNetwork.result

    assert result == :no_data
  end
end
