defmodule ExLearn.NeuralNetwork.Worker do
  use GenServer

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.{Forwarder, Notification, Propagator, Store}

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

    Notification.push("Asking", logger)
    result = ask_network(batch, network_state)
    Notification.push("Finished Asking", logger)

    {:reply, result, state}
  end

  @spec handle_call({}, any, map) :: {}
  def handle_call({:test, batch, configuration}, _from, state) do
    %{
      logger_name: logger,
      state_name:  state_name
    } = state

    network_state = Store.get_state(state_name)

    Notification.push("Testing", logger)
    result = test_network(batch, configuration, network_state)
    Notification.push("Finished Testing", logger)

    {:reply, result, state}
  end

  @spec handle_call({}, any, map) :: {}
  def handle_call({:train, batch, configuration}, _from, state) do
    %{
      logger_name: logger,
      state_name:  state_name
    } = state

    network_state = Store.get_state(state_name)

    Notification.push("Training", logger)
    new_network_state = train_network(batch, configuration, network_state)
    Notification.push("Finished Training", logger)

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

  defp ask_network(batch, state) do
    Enum.map(batch, &Forwarder.forward_for_output(&1, state))
  end

  defp test_network(batch, configuration, state) do
    outputs = Enum.map(batch, &Forwarder.forward_for_test(&1, state))

    %{network: %{objective: %{function: objective}}} = state
    %{data_size: data_size} = configuration

    targets = Enum.map(batch, fn ({_, target}) -> target end)

    costs = Enum.zip(targets, outputs)
    |> Enum.map(fn ({target, output}) ->
      %{output: output_for_objective} = output

      objective.(target, output_for_objective, data_size)
    end)

    {outputs, costs}
  end

  @spec train_network(list, map, map) :: map
  defp train_network([sample|batch], configuration, state) do
    correction = train_sample(sample, configuration, state)

    train_network(batch, correction, configuration, state)
  end

  defp train_network([], total_correction, configuration, state) do
    Propagator.apply_changes(total_correction, configuration, state)
  end

  defp train_network([sample|batch], total_correction, configuration, state) do
    correction     = train_sample(sample, configuration, state)
    new_correction = accumulate_correction(correction, total_correction)

    train_network(batch, new_correction, configuration, state)
  end

  defp accumulate_correction(correction, total) do
    {bias_correction, weight_correction} = correction
    {bias_total,      weight_total     } = total

    bias_final = Enum.zip(bias_correction, bias_total)
    |> Enum.map(fn({x, y}) -> Matrix.add(x, y) end)

    weight_final = Enum.zip(weight_correction, weight_total)
    |> Enum.map(fn({x, y}) -> Matrix.add(x, y) end)

    {bias_final, weight_final}
  end

  defp train_sample(sample, configuration, state) do
    Forwarder.forward_for_activity(sample, state)
    |> Propagator.back_propagate(configuration, state)
  end
end
