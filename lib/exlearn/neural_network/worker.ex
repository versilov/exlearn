defmodule ExLearn.NeuralNetwork.Worker do
  use GenServer

  alias ExLearn.NeuralNetwork.{Forwarder, Propagator}

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

  @spec start([{}], map, map) :: {}
  def start(batch, configuration, network_state) do
    name = {:global, make_ref()}

    GenServer.start(
      __MODULE__,
      {batch, configuration, network_state},
      name: name
    )

    name
  end

  @spec start_link([{}], map, map) :: {}
  def start_link(batch, configuration, network_state) do
    name = {:global, make_ref()}

    {:ok, _pid} = GenServer.start_link(
      __MODULE__,
      {batch, configuration, network_state},
      name: name
    )

    name
  end

  # Server API

  @spec init([]) :: {}
  def init([]) do
    state = %{batch: [], configuration: %{}, network_state: %{}}

    {:ok, state}
  end

  @spec handle_call({}, map) :: {}
  def handle_call({:ask, batch}, state) do
    result = ask_network(batch, state)

    {:reply, result, state}
  end

  @spec handle_call({}, map) :: {}
  def handle_call({:test, batch, configuration}, state) do
    result = test_network(batch, configuration, state)

    {:reply, result, state}
  end

  @spec handle_call({}, map) :: {}
  def handle_call({:train, batch, configuration}, state) do
    new_state = train_network(batch, configuration, state)

    {:reply, :ok, new_state}
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

  defp ask_network(input, state) do
    Forwarder.forward_for_output(input, state)
  end

  defp test_network(batch, configuration, state) do
    outputs = Forwarder.forward_for_test(batch, state)

    %{network: %{objective: %{function: objective}}} = state
    %{data_size: data_size} = configuration

    targets = Enum.map(batch, fn ({_, target}) -> target end)

    costs = Enum.zip(targets, outputs)
      |> Enum.map(fn ({target, output}) -> objective.(target, output, data_size) end)

    {outputs, costs}
  end

  @spec train_network(list, map, map) :: map
  defp train_network(batch, configuration, state) do
    batch
    |> Forwarder.forward_for_activity(state)
    |> Propagator.back_propagate(configuration, state)
  end
end
