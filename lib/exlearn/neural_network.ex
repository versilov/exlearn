defmodule ExLearn.NeuralNetwork do
  @moduledoc """
  A neural network
  """

  alias ExLearn.NeuralNetwork.{Accumulator, Master, Notification}

  @doc """
  Makes a prediction
  """
  @spec ask(any, any) :: any
  def ask(data, network) do
    %{accumulator: accumulator} = network

    Accumulator.ask(data, accumulator)
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
  Trains the neural network
  """
  @spec train(list, map, any) :: any
  def train(data, configuration, network) do
    %{accumulator: accumulator} = network

    Accumulator.train(data, configuration, accumulator)
  end
end
