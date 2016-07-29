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
    %{worker: worker} = network

    Worker.ask(data, worker)
  end

  @doc """
  Feeds input to the NeuralNetwork
  """
  @spec feed(list, map, pid) :: atom
  def feed(data, configuration, network) do
    Task.async(fn ->
      %{epochs: epochs} = configuration
      %{logger: logger} = network
      Notification.push("Started feeding data", logger)

      feed_network(data, configuration, network, epochs)
    end)
  end

  @spec feed_network(list, map, pid, non_neg_integer) :: atom
  defp feed_network(_, _, network, 0) do
    %{logger: logger} = network
    Notification.push("Finished feeding data", logger)
    Notification.done(logger)

    :ok
  end

  defp feed_network(data, configuration, network, epochs)
      when is_integer(epochs) and epochs > 0 do
    %{logger: logger} = network
    Notification.push("Epoch #{epochs}", logger)

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
      logger_name: logger_name = {:global, make_ref()},
      master_name: master_name = {:global, make_ref()},
      state_name:  state_name  = {:global, make_ref()},
      worker_name: worker_name = {:global, make_ref()}
    }

    args    = {parameters, names}
    options = [name: master_name]

    {:ok, _pid} = Master.start_link(args, options)

    %{
      logger: logger_name,
      master: master_name,
      state:  state_name,
      worker: worker_name
    }
  end

  @doc """
  Starts the notification stream
  """
  @spec notifications(any) :: Task.t
  def notifications(network) do
    %{logger: logger} = network

    Notification.stream(logger)
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
