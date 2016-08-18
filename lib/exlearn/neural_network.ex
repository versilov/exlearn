defmodule ExLearn.NeuralNetwork do
  @moduledoc """
  A neural network.
  """

  alias ExLearn.NeuralNetwork.{
    Accumulator, Builder, Master, Notification, Persistence, Store
  }

  @doc """
  Makes a prediction.
  """
  @spec ask(any, any) :: any
  def ask(data, network) do
    %{accumulator: accumulator} = network

    Task.async(fn ->
      Accumulator.ask(data, accumulator)
    end)
  end

  @doc """
  Creates the neural network from the structure parameters.
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
  @spec initialize(map, map) :: pid
  def initialize(parameters, network) do
    Store.get(network)
    |> Builder.initialize(parameters)
    |> Store.set(network)
  end

  @doc """
  Loads the network biases and weights from a file.
  """
  @spec load(String.t, any) :: :ok
  def load(name, network) do
    Store.get(network)
    |> Persistence.load(name)
    |> Store.set(network)
  end

  @doc """
  Starts the notification stream.
  """
  @spec notifications(atom, any) :: Task.t
  def notifications(:start, network) do
    %{notification: notification} = network

    Notification.stream(notification)
  end

  @doc """
  Stops the notification stream.
  """
  @spec notifications(atom, any) :: Task.t
  def notifications(:stop, network) do
    %{notification: notification} = network

    Notification.done(notification)
  end

  @doc """
  Saves the network biases and weights to a file.
  """
  @spec save(String.t, any) :: :ok
  def save(name, network) do
    Store.get(network)
    |> Persistence.save(name)
  end

  @doc """
  Trains the neural network.
  """
  @spec train(map, any) :: any
  def train(learning_parameters, network) do
    %{accumulator: accumulator} = network

    Task.async(fn ->
      Accumulator.train(learning_parameters, accumulator)
    end)
  end
end
