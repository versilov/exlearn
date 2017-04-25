defmodule ExLearn.NeuralNetwork.Manager do
  use Supervisor

  alias ExLearn.NeuralNetwork.Worker

  #-----------------------------------------------------------------------------
  # Client API
  #-----------------------------------------------------------------------------

  @spec start_link(map, map) :: pid
  def start_link(args, options) do
    Supervisor.start_link(__MODULE__, args, options)
  end

  #-----------------------------------------------------------------------------
  # Server API
  #-----------------------------------------------------------------------------

  @spec init([]) :: {:ok, any}
  def init([]) do
    children = [
      worker(Worker, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
