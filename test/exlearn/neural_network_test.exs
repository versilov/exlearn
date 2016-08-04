defmodule NeuralNetworkTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.NeuralNetwork
  alias ExLearn.NeuralNetwork.Notification

  setup do
    network_parameters = %{
      layers: %{
        input:  %{size: 1},
        hidden: [
          %{
            activity: :identity,
            name:     "First Hidden",
            size:     1
          }
        ],
        output: %{
          activity: :identity,
          name:     "Output",
          size:     1
        }
      },
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    network = NeuralNetwork.initialize(network_parameters)

    training_data = [
      {[0], [0]},
      {[1], [1]},
      {[2], [2]},
      {[3], [3]},
      {[4], [4]},
      {[5], [5]}
    ]

    ask_data = [[0], [1], [2], [3], [4], [5]]

    configuration = %{
      batch_size:     2,
      data_size:      6,
      dropout:        0.5,
      epochs:         5,
      learning_rate:  0.005,
      regularization: :L2
    }

    {:ok, setup: %{
      ask_data:      ask_data,
      configuration: configuration,
      network:       network,
      test_data:     training_data,
      training_data: training_data
    }}
  end

  test "#ask responds with a list of numbers", %{setup: setup} do
    %{ask_data: data, network: network} = setup

    result = NeuralNetwork.ask(data, network)

    assert length(result) == length(data)
    Enum.each(result, fn (element) ->
      assert element |> is_list
      Enum.each(element, fn (number) ->
        assert number |> is_number
      end)
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

  test "#train responds with a tuple", %{setup: setup} do
    %{
      configuration: configuration,
      network:       network,
      training_data: training_data,
    } = setup

    expected = :ok

    result = NeuralNetwork.train(training_data, configuration, network)

    assert expected == result
  end
end
