defmodule ExLearn.NeuralNetwork.Worker do
  use GenServer

  alias ExLearn.NeuralNetwork.{Logger, Store, Forwarder, Propagator}

  # Client API

  @spec ask(any, any) :: any
  def ask(batch, worker) do
    GenServer.call(worker, {:ask, batch}, :infinity)
  end

  @spec test(any, any, any) :: any
  def test(batch, configuration, worker) do
    GenServer.call(worker, {:test, batch, configuration}, :infinity)
  end

  @spec train(any, any, any) :: any
  def train(batch, configuration, worker) do
    GenServer.call(worker, {:train, batch, configuration}, :infinity)
  end

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

  @spec start([{}], map) :: {}
  def start(args, options) do
    GenServer.start( __MODULE__, args, options)
  end

  @spec start_link([{}], map) :: {}
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  # Server API

  @spec init(any) :: {}
  def init(names) do
    %{
      logger_name: logger_name,
      state_name:  state_name
    } = names

    state = %{
      batch:         [],
      configuration: %{},
      network_state: %{},
      state_name:    state_name,
      logger_name:   logger_name
    }

    {:ok, state}
  end

  @spec handle_call({}, any,  map) :: {}
  def handle_call({:ask, batch}, _from,  state) do
    %{
      logger_name: logger,
      state_name:  state_name
    } = state

    network_state = Store.get_state(state_name)

    Logger.log("Asking", logger)
    result = ask_network(batch, network_state)
    Logger.log("Finished Asking", logger)

    {:reply, result, state}
  end

  @spec handle_call({}, any, map) :: {}
  def handle_call({:test, batch, configuration}, _from, state) do
    %{
      logger_name: logger,
      state_name:  state_name
    } = state

    network_state = Store.get_state(state_name)

    Logger.log("Testing", logger)
    result = test_network(batch, configuration, network_state)
    Logger.log("Finished Testing", logger)

    {:reply, result, state}
  end

  @spec handle_call({}, any, map) :: {}
  def handle_call({:train, batch, configuration}, _from, state) do
    %{
      logger_name: logger,
      state_name:  state_name
    } = state

    network_state = Store.get_state(state_name)

    Logger.log("Training", logger)
    new_network_state = train_network(batch, configuration, network_state)
    Logger.log("Finished Training", logger)

    Store.set_state(new_network_state, state_name)

    {:reply, :ok, state}
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
