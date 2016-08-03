defmodule ExLearn.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias ExLearn.NeuralNetwork.{Master, Notification,  Worker}

  @doc """
  Makes a prediction
  """
  @spec ask(any, any) :: any
  def ask(data, network) do
    %{accumulator: accumulator} = network

    Worker.ask(data, accumulator)
  end

  @doc """
  Feeds input to the NeuralNetwork
  """
  @spec feed(list, map, pid) :: atom
  def feed(data, configuration, network) do
    Task.async(fn ->
      %{epochs: epochs} = configuration
      %{notification: notification} = network
      Notification.push("Started feeding data", notification)

      feed_network(data, configuration, network, epochs)
    end)
  end

  @spec feed_network(list, map, pid, non_neg_integer) :: atom
  defp feed_network(_, _, network, 0) do
    %{notification: notification} = network
    Notification.push("Finished feeding data", notification)

    :ok
  end

  defp feed_network(data, configuration, network, epochs)
      when is_integer(epochs) and epochs > 0 do
    %{notification: notification} = network
    Notification.push("Epoch #{epochs}", notification)

    %{batch_size: batch_size} = configuration
    batches = Enum.shuffle(data) |> Enum.chunk(batch_size)

    Enum.each(batches, fn(batch) ->
      train(batch, configuration, network)
    end)

    feed_network(data, configuration, network, epochs - 1)
  end

  @doc """
  Initalizez the neural network
  """
  @spec initialize(map) :: pid
  def initialize(parameters) do
    names = %{
      accumulator:  accumulator  = {:global, make_ref()},
      manager:      manager      = {:global, make_ref()},
      master:       master       = {:global, make_ref()},
      notification: notification = {:global, make_ref()},
      store:        store        = {:global, make_ref()}
    }

    args    = {parameters, names}
    options = [name: master]

    {:ok, _pid} = Master.start_link(args, options)

    %{
      accumulator:  accumulator,
      manager:      manager,
      master:       master,
      notification: notification,
      store:        store,
    }
  end

  @doc """
  Starts the notification stream
  """
  @spec notifications(atom, any) :: Task.t
  def notifications(:start, network) do
    %{notification: notification} = network

    Notification.stream(notification)
  end

  @doc """
  Stops the notification stream
  """
  @spec notifications(atom, any) :: Task.t
  def notifications(:stop, network) do
    %{notification: notification} = network

    Notification.done(notification)
  end

  @doc """
  Makes a prediction and returs the cost
  """
  @spec test(any, map, any) :: any
  def test(batch, configuration, network) do
    %{worker: worker} = network

    Worker.test(batch, configuration, worker)
  end

  @doc """
  Trains the neural network
  """
  @spec train(list, map, any) :: any
  def train(batch, configuration, network) do
    %{worker: worker} = network

    Worker.train(batch, configuration, worker)
  end

  # @doc """
  # Returns a snapshot of the neural network
  # """
  # @spec inspect(pid) :: map
  # def inspect(pid) do
  #   send pid, :inspect
  # end

  # @doc """
  # Returns a snapshot of a certain part of the neural network
  # """
  # @spec inspect(atom, pid) :: map
  # def inspect(input, pid) do
  #   send pid, {:inspect, input}
  # end

  # @doc """
  # Saves the neural network to disk
  # """
  # @spec save(pid) :: any
  # def save(pid) do
  #   pid
  # end

  # @doc """
  # Loads the neural network from disk
  # """
  # @spec load(any) :: pid
  # def load(file) do
  #   file
  # end
end
