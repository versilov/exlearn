defmodule ExLearn.NeuralNetwork.Master do
  use Supervisor

  alias ExLearn.NeuralNetwork.{Notification, Store, Worker}

  # Client API

  @spec start_link(map, map) :: pid
  def start_link(args, options) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  # Supervisor API

  @spec init({}) :: {}
  def init({parameters, names}) do
    %{
      logger_name: logger_name,
      state_name:  state_name,
      worker_name: worker_name
    } = names

    children = [
      worker(Notification, [[],                  [name: logger_name]]),
      worker(Store,        [{parameters, names}, [name: state_name ]]),
      worker(Worker,       [names,               [name: worker_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
