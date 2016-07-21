defmodule ExLearn.NeuralNetwork.Worker do
  use GenServer

  # Client API

  @spec set_batch([{}], pid) :: atom
  def set_batch(new_value, worker) do
    GenServer.cast(worker, {:batch, new_value})
  end

  @spec set_configuration([{}], pid) :: atom
  def set_configuration(new_value, worker) do
    GenServer.cast(worker, {:configuration, new_value})
  end

  @spec set_network_state([{}], pid) :: atom
  def set_network_state(new_value, worker) do
    GenServer.cast(worker, {:network_state, new_value})
  end

  @spec start([{}], map, map) :: pid
  def start(batch, configuration, network_state) do
    GenServer.start(
      __MODULE__,
      {batch, configuration, network_state}
    )
  end

  # Server API

  @spec init({}) :: {}
  def init({batch, configuration, network_state}) do
    state = %{
      batch:         batch,
      configuration: configuration,
      network_state: network_state
    }

    {:ok, state}
  end

  @spec handle_cast({}, map) :: {}
  def handle_cast({:batch, new_value}, state) do
    new_state = Map.put(state, :batch, new_value)

    {:noreply, new_state}
  end

  @spec handle_cast({}, map) :: {}
  def handle_cast({:configuration, new_value}, state) do
    new_state = Map.put(state, :configuration, new_value)

    {:noreply, new_state}
  end

  @spec handle_cast({}, map) :: {}
  def handle_cast({:network_state, new_value}, state) do
    new_state = Map.put(state, :network_state, new_value)

    {:noreply, new_state}
  end
end
