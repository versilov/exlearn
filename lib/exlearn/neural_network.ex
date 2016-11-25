defmodule ExLearn.NeuralNetwork do
  @moduledoc """
  Handles the lifecycle of a neural network.

  All functions inside this module are part of the public API.
  """

  alias ExLearn.NeuralNetwork.Accumulator
  alias ExLearn.NeuralNetwork.Builder
  alias ExLearn.NeuralNetwork.Master
  alias ExLearn.NeuralNetwork.Notification
  alias ExLearn.NeuralNetwork.Persistence
  alias ExLearn.NeuralNetwork.Store

  @doc """
  Creates the neural network processes and returns a handle.

  Example usage:

      structure = %{
        layers: %{
          input:   %{size: 784, dropout: 0.2                       },
          hidden: [%{size: 100, dropout: 0.5, activation: :logistic}],
          output:  %{size: 10,                activation: :logistic}
        },
        objective:    :cross_entropy,
        presentation: :argmax
      }

      network = create(structure)

  For a more detailed description of the structure parameter see the
  `elixir_modules.md` file inside the `docs` directory.
  """
  @spec create(map) :: map
  def create(structure) do
    network_state = Builder.create(structure)

    args = %{
      accumulator:  accumulator  = {:global, make_ref()},
      manager:      manager      = {:global, make_ref()},
      master:       master       = {:global, make_ref()},
      notification: notification = {:global, make_ref()},
      store:        store        = {:global, make_ref()}
    }
    options = [name: master]

    {:ok, _pid} = Master.start_link(args, options)

    network = %{
      accumulator:  accumulator,
      manager:      manager,
      master:       master,
      notification: notification,
      store:        store,
    }

    :ok = Store.set(network_state, network)

    network
  end

  @doc """
  Initalizez the neural network.
  """
  @spec initialize(map, map) :: map
  def initialize(network, parameters) do
    Store.get(network)
    |> Builder.initialize(parameters)
    |> Store.set(network)

    network
  end

  @doc """
  Loads the network biases and weights from a file.
  """
  @spec load(map, String.t) :: map
  def load(network, name) do
    :ok = Store.get(network) |> Persistence.load(name) |> Store.set(network)

    network
  end

  @doc """
  Starts the notification stream.
  """
  @spec notifications(any, atom) :: map
  def notifications(network, :start) do
    %{notification: notification} = network

    pid = Notification.stream(notification)

    Map.put(network, :notification_pid, pid)
  end

  @doc """
  Stops the notification stream.
  """
  @spec notifications(atom, any) :: map
  def notifications(network, :stop) do
    %{notification: notification} = network

    Notification.done(notification)

    case Map.get(network, :notification_pid) do
      nil -> network
      pid ->
        Process.exit(pid, :normal)

        Map.delete(network, :notification_pid)
    end
  end

  @doc """
  Makes a prediction.
  """
  @spec predict(map, any) :: any
  def predict(network, data) do
    %{accumulator: accumulator} = network

    %{predict: predict} = data
    predict_data        = %{predict: predict}
    Accumulator.process(predict_data, %{}, accumulator)

    network
  end

  @spec predict(any, any, any) :: map
  def predict(network, data, parameters) do
    %{accumulator: accumulator} = network

    %{predict: predict} = data
    predict_data        = %{predict: predict}
    Accumulator.process(predict_data, parameters, accumulator)

    network
  end

  @spec process(any, any, any) :: map
  def process(network, data, parameters) do
    %{accumulator: accumulator} = network

    Accumulator.process(data, parameters, accumulator)

    network
  end

  @doc """
  Returns the result.
  """
  @spec result(any) :: any
  def result(network) do
    %{accumulator: accumulator} = network

    Accumulator.get(accumulator)
  end

  @doc """
  Saves the network biases and weights to a file.
  """
  @spec save(any, String.t) :: map
  def save(network, name) do
    :ok = Store.get(network) |> Persistence.save(name)

    network
  end

  @doc """
  Tests the neural network.
  """
  @spec test(map, map, map) :: map
  def test(network, data, parameters) do
    %{accumulator: accumulator} = network

    %{test: test} = data
    test_data     = %{test: test}
    Accumulator.process(test_data, parameters, accumulator)

    network
  end

  @doc """
  Trains the neural network.
  """
  @spec train(map, map, map) :: map
  def train(network, data, parameters) do
    %{accumulator: accumulator} = network

    %{train: train} = data
    train_data      = %{train: train}
    Accumulator.process(train_data, parameters, accumulator)

    network
  end
end
