defmodule ExLearn.NeuralNetworkTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.NeuralNetwork
  alias ExLearn.NeuralNetwork.Notification

  setup do
    structure_parameters = %{
      layers: %{
        input:   %{size: 1},
        hidden: [%{activity: :identity, name: "First Hidden", size:1}],
        output:  %{activity: :identity, name: "Output",       size:1}
      },
      objective: :quadratic
    }

    network = NeuralNetwork.create(structure_parameters)

    initialization_parameters = %{distribution: :uniform, range: {-1, 1}}
    NeuralNetwork.initialize(initialization_parameters, network)

    training_data = [
      {[0], [0]},
      {[1], [1]},
      {[2], [2]},
      {[3], [3]},
      {[4], [4]},
      {[5], [5]}
    ]

    validation_data = [
      {[6], [6]},
      {[7], [7]}
    ]

    test_data = [
      {[8], [8]},
      {[9], [9]}
    ]

    ask_data = [[0], [1], [2], [3], [4], [5]]

    learning_parameters = %{
      training: %{
        batch_size:    2,
        data:          training_data,
        data_size:     6,
        epochs:        5,
        learning_rate: 0.05,
      },
      validation: %{
        data:      validation_data,
        data_size: 2
      },
      test: %{
        data:      test_data,
        data_size: 2
      }
      workers: 2
    }

    {:ok, setup: %{
      ask_data:            ask_data,
      learning_parameters: learning_parameters,
      network:             network
    }}
  end

  test "#ask responds with a list of numbers", %{setup: setup} do
    %{ask_data: ask_data, network: network} = setup

    result = NeuralNetwork.ask(ask_data, network)
    |> Task.await(:infinity)

    assert length(result) == length(ask_data)
    Enum.each(result, fn(element) ->
      assert element |> is_list
      Enum.each(element, fn(number) -> assert is_number(number) end)
    end)
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

    timestamp = :os.system_time(:micro_seconds) |> to_string
    path      = "test/temp/exlearn-neural_network_test" <> timestamp

    :ok = NeuralNetwork.save(path, network)

    assert NeuralNetwork.load(path, network) == :ok

    :ok = File.rm(path)
  end

  test "#notifications returns an async task", %{setup: setup} do
    %{network: network} = setup

    :ok = Notification.push("Message", network)

    result = capture_io(fn ->
      Task.start(fn ->
        NeuralNetwork.notifications(:start, network)
        |> Task.await
      end)
      NeuralNetwork.notifications(:stop, network)

      Process.sleep(100)
    end)

    assert result == "Initializing state\nFinished initializing state\nMessage\n"
  end

  test "#save responds with :ok", %{setup: setup} do
    %{network: network} = setup

    timestamp = :os.system_time(:micro_seconds) |> to_string
    path      = "test/temp/exlearn-neural_network_test" <> timestamp

    assert NeuralNetwork.save(path, network) == :ok

    :ok = File.rm(path)
  end

  test "#train responds with :ok", %{setup: setup} do
    %{
      configuration: configuration,
      network:       network,
      training_data: training_data,
    } = setup

    result = NeuralNetwork.train(training_data, configuration, network)
    |> Task.await(:infinity)

    assert result == :ok
  end
end
