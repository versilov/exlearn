defmodule ExLearn.NeuralNetwork.Store do
  use GenServer

  alias ExLearn.NeuralNetwork.{Builder, Notification}

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

  @spec init({}) :: {}
  def init({parameters, names}) do
    %{logger_name: logger} = names

    Notification.log("Initializing state", logger)
    state = Builder.initialize(parameters)
    Notification.log("Finished initializing state", logger)

    {:ok, %{
      logger:        logger,
      network_state: state
    }}
  end

  @spec handle_call(atom, {}, map) :: {}
  def handle_call(:get, _from, state) do
    %{
      logger:        logger,
      network_state: network_state
    } = state

    Notification.log("State requested", logger)

    {:reply, network_state, state}
  end

  @spec handle_cast(atom, map) :: {}
  def handle_cast({:set, new_network_state}, state) do
    %{logger: logger} = state

    new_state = Map.put(state, :network_state, new_network_state)
    Notification.log("New state set", logger)

    {:noreply, new_state}
  end
end
