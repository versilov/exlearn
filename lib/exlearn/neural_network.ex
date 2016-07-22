defmodule ExLearn.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias ExLearn.NeuralNetwork.{Master, Worker}

  @doc """
  Makes a prediction
  """
  @spec ask(any, any) :: any
  def ask(data, network) do
    {_, _, worker} = network

    Worker.ask(data, worker)
  end

  @doc """
  Feeds input to the NeuralNetwork
  """
  @spec feed(list, map, pid) :: atom
  def feed(data, configuration, network) do
    %{epochs: epochs} = configuration

    feed_network(data, configuration, network, epochs)
  end

  @spec feed_network(list, map, pid, non_neg_integer) :: atom
  defp feed_network(_, _, _, 0), do: :ok
  defp feed_network(data, configuration, network, epochs)
      when is_integer(epochs) and epochs > 0 do

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
      master_name: master_name = {:global, make_ref()},
      state_name:  state_name  = {:global, make_ref()},
      worker_name: worker_name = {:global, make_ref()}
    }

    args    = {parameters, names}
    options = [name: master_name]

    {:ok, pid} = Master.start_link(args, options)

    {master_name, state_name, worker_name}
  end

  @doc """
  Makes a prediction and returs the cost
  """
  @spec test(any, map, any) :: any
  def test(batch, configuration, network) do
    {_, _, worker} = network

    Worker.test(batch, configuration, worker)
  end

  @doc """
  Trains the neural network
  """
  @spec train(list, map, any) :: any
  def train(batch, configuration, network) do
    {_, _, worker} = network

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
