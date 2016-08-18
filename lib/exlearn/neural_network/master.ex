defmodule ExLearn.NeuralNetwork.Master do
  use Supervisor

  alias ExLearn.NeuralNetwork.{Accumulator, Manager, Notification, Store}

  # Client API

  @spec start_link(map, map) :: pid
  def start_link(args, options) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  # Supervisor API
  @spec init(map) :: any
  def init(names) do
    %{
      accumulator:  accumulator,
      manager:      manager,
      notification: notification,
      store:        store
    } = names

    children = [
      worker(Accumulator,  [names, [name: accumulator ]]),
      worker(Manager,      [[],    [name: manager     ]]),
      worker(Notification, [[],    [name: notification]]),
      worker(Store,        [names, [name: store       ]]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
