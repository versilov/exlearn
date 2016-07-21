defmodule ExLearn.NeuralNetwork.State do
  alias ExLearn.NeuralNetwork.Builder

  use GenServer

  # Client API

  @spec start(map) :: pid
  def start(parameters) do
    GenServer.start(__MODULE__, parameters)
  end

  @spec get_state(pid) :: map
  def get_state(server) do
    GenServer.call(server, :get)
  end

  # Server API

  @spec init(%{}) :: {}
  def init(parameters) do
    state = Builder.initialize(parameters)

    {:ok, state}
  end

  @spec handle_call(atom, {}, map) :: {}
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
