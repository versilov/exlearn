defmodule ExLearn.NeuralNetwork.Master do
  use Supervisor

  alias ExLearn.NeuralNetwork.{State, Worker}

  # Client API

  @spec start_link(map, map) :: pid
  def start_link(parameters, names) do
    %{master_name: master_name} = names

    Supervisor.start_link(
      __MODULE__, {parameters, names}, name: master_name
    )
  end

  # Supervisor API

  @spec init({}) :: {}
  def init({parameters, names}) do
    %{state_name: state_name, worker_name: worker_name} = names

    children = [
      worker(State,  parameters, name: state_name),
      worker(Worker, [],         name: worker_name)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
