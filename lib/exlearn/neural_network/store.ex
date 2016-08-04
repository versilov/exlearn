defmodule ExLearn.NeuralNetwork.Store do
  use GenServer

  alias ExLearn.NeuralNetwork.{Builder, Notification}

  # Client API

  @spec get(%{store: {:global, reference}}) :: {}
  def get(%{store: store = {:global, _reference}}) do
    GenServer.call(store, :get)
  end

  @spec get({:global, reference}) :: {}
  def get(store = {:global, _reference}) do
    GenServer.call(store, :get)
  end

  @spec set(map, %{store: {:global, reference}}) :: {}
  def set(state, %{store: store = {:global, _reference}}) do
    GenServer.call(store, {:set, state})
  end

  @spec set(map, {:global, reference}) :: {}
  def set(state, store = {:global, _reference}) do
    GenServer.call(store, {:set, state})
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

  @spec init({}) :: {}
  def init({parameters, names}) do
    %{notification: notification} = names

    Notification.push("Initializing state", notification)
    state = Builder.initialize(parameters)
    Notification.push("Finished initializing state", notification)

    {:ok, %{
      notification:  notification,
      network_state: state
    }}
  end

  @spec handle_call(atom, {}, map) :: {}
  def handle_call(:get, _from, state) do
    %{
      notification:  notification,
      network_state: network_state
    } = state

    Notification.push("State requested", notification)

    {:reply, network_state, state}
  end

  @spec handle_call(atom, {},  map) :: {}
  def handle_call({:set, new_network_state}, _from, state) do
    %{notification: notification} = state

    new_state = Map.put(state, :network_state, new_network_state)
    Notification.push("New state set", notification)

    {:reply, :ok, new_state}
  end
end
