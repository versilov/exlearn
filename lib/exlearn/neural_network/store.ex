defmodule ExLearn.NeuralNetwork.Store do
  use GenServer

  # Client API

  @spec get(%{store: {:global, reference}}) :: tuple
  def get(%{store: store = {:global, _reference}}) do
    GenServer.call(store, :get)
  end

  @spec get({:global, reference}) :: tuple
  def get(store = {:global, _reference}) do
    GenServer.call(store, :get)
  end

  @spec set(map, %{store: {:global, reference}}) :: tuple
  def set(state, %{store: store = {:global, _reference}}) do
    GenServer.call(store, {:set, state})
  end

  @spec set(map, {:global, reference}) :: tuple
  def set(state, store = {:global, _reference}) do
    GenServer.call(store, {:set, state})
  end

  @spec start(map, tuple) :: reference
  def start(args, options) do
    GenServer.start(__MODULE__, args, options)
  end

  @spec start_link(map, tuple) :: reference
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  # Server API

  @spec init(map) :: {:ok, map}
  def init(names) do
    %{notification: notification} = names

    {:ok, %{
      notification:  notification,
      network_state: :network_state_not_set
    }}
  end

  @spec handle_call(atom, tuple, map) :: {:reply, map, map}
  def handle_call(:get, _from, state) do
    %{network_state: network_state} = state

    {:reply, network_state, state}
  end

  @spec handle_call(atom, tuple,  map) :: {:reply, :ok, map}
  def handle_call({:set, new_network_state}, _from, state) do
    new_state = Map.put(state, :network_state, new_network_state)

    {:reply, :ok, new_state}
  end
end
