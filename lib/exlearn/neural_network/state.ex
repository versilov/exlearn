defmodule ExLearn.NeuralNetwork.State do
  alias ExLearn.NeuralNetwork.Builder

  use GenServer

  # Client API

  @spec get_state(pid) :: map
  def get_state(server) do
    GenServer.call(server, :get)
  end

  @spec start(map) :: reference
  def start(parameters) do
    name = {:global, make_ref()}

    {:ok, _pid} = GenServer.start(__MODULE__, parameters, name: name)

    name
  end

  @spec start_link(map) :: reference
  def start_link(parameters) do
    name = {:global, make_ref()}

    {:ok, _pid} = GenServer.start_link(__MODULE__, parameters, name: name)

    name
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
