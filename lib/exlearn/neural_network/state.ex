defmodule ExLearn.NeuralNetwork.State do
  use GenServer

  alias ExLearn.NeuralNetwork.Builder

  # Client API

  @spec get_state(pid) :: map
  def get_state(server) do
    GenServer.call(server, :get)
  end

  @spec set_state(map, pid) :: map
  def set_state(state, server) do
    GenServer.cast(server, {:set, state})
  end

  @spec start(map, {}) :: reference
  def start(args, options) do
    GenServer.start(__MODULE__, args, options)
  end

  @spec start_link(map, {}) :: reference
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
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

  @spec handle_cast(atom, map) :: {}
  def handle_cast({:set, new_state}, _state) do
    {:noreply, new_state}
  end
end
