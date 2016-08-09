defmodule ExLearn.NeuralNetwork.Worker do
  use GenServer

  alias ExLearn.Util
  alias ExLearn.NeuralNetwork.{Forwarder, Propagator}

  #----------------------------------------------------------------------------
  # Client API
  #----------------------------------------------------------------------------

  @spec prepare(any) :: any
  def prepare(worker) do
    GenServer.call(worker, :prepare, :infinity)
  end

  @spec work(:ask, map, any) :: any
  def work(:ask, network_state, worker) do
    GenServer.call(worker, {:ask, network_state}, :infinity)
  end

  @spec work(:test, map, any) :: any
  def work(:test, network_state, worker) do
    GenServer.call(worker, {:test, network_state}, :infinity)
  end

  @spec work(:train, map,  any) :: any
  def work(:train, network_state, worker) do
    GenServer.call(worker, {:train, network_state}, :infinity)
  end

  @spec start([{}], map) :: {}
  def start(args, options) do
    GenServer.start(__MODULE__, args, options)
  end

  @spec start_link([{}], map) :: {}
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  #----------------------------------------------------------------------------
  # Server API
  #----------------------------------------------------------------------------

  @spec init(any) :: {}
  def init(configuration) do
    %{
      batch_size:    batch_size,
      data:          data_source,
      learning_rate: learning_rate
    } = configuration

    data = case List.first(data_source) do
      path when is_bitstring(path) -> read_data(data_source)
      _  -> data_source
    end

    state = %{
      batch_size:    batch_size,
      batches:       %{current: :not_set, remaining: :not_set},
      data:          data,
      learning_rate: learning_rate
    }

    {:ok, state}
  end

  @spec handle_call({}, any,  map) :: {}
  def handle_call(:prepare, _from, state) do
    %{
      batch_size: batch_size,
      data:       data
    } = state

    batches = case data do
      [] ->
        %{current: :not_set, remaining: :not_set}
      _  ->
        [current|remaining] = Enum.chunk(data, batch_size)

        %{current: current, remaining: remaining}
    end

    new_state = Map.put(state, :batches, batches)

    {:reply, :ok, new_state}
  end

  @spec handle_call({}, any,  map) :: {}
  def handle_call({:ask, network_state}, _from,  state) do
    %{data: data} = state

    result = ask_network(data, network_state)

    {:reply, result, state}
  end

  @spec handle_call({}, any, map) :: {}
  def handle_call({:test, network_state}, _from, state) do
    %{
      configuration: configuration,
      data:          data
    } = state

    result = test_network(data, configuration, network_state)

    {:reply, result, state}
  end

  @spec handle_call({}, any, map) :: {}
  def handle_call({:train, network_state}, _from, state) do
    %{
      batches: %{
        current:   current,
        remaining: remaining
      }
    } = state

    case current do
      :not_set ->
        {:reply, :no_data, state}
      _ ->
        correction = train_network(current, network_state)

        case remaining do
          [] ->
            new_batches = %{current: :not_set, remaining: :not_set}
            new_state   = Map.put(state, :batches, new_batches)

            {:reply, {:done, correction}, new_state}

          [new_current|new_remaining] ->
            new_batches = %{current: new_current, remaining: new_remaining}
            new_state   = Map.put(state, :batches, new_batches)

            {:reply, {:continue, correction}, new_state}
        end
    end
  end

  #----------------------------------------------------------------------------
  # Internal functions
  #----------------------------------------------------------------------------

  defp ask_network(batch, state) do
    Enum.map(batch, &Forwarder.forward_for_output(&1, state))
  end

  @spec read_data([bitstring]) :: list
  defp read_data(paths) do
    Enum.reduce(paths, [], &read_file/2)
  end

  @spec read_file(bitstring, list) :: list
  defp read_file(path, accumulator) do
    {:ok, binary} = File.read(path)
    data          = :erlang.binary_to_term(binary)

    data ++ accumulator
  end

  defp test_network(batch, configuration, state) do
    outputs = Enum.map(batch, &Forwarder.forward_for_test(&1, state))

    %{network: %{objective: %{function: objective}}} = state
    %{data_size: data_size} = configuration

    targets = Enum.map(batch, fn ({_, target}) -> target end)

    costs = Util.zip_map(targets, outputs, fn (target, output) ->
      %{output: output_for_objective} = output

      objective.(target, output_for_objective, data_size)
    end)

    {outputs, costs}
  end

  @spec train_network(list, map, map) :: map
  defp train_network([sample|batch], network_state) do
    first_correction = train_sample(sample, network_state)

    train_network(batch, first_correction, network_state)
  end

  defp train_network([], correction, _), do: correction
  defp train_network([sample|batch], accumulator, network_state) do
    new_correction = train_sample(sample, network_state)
    result         = Propagator.reduce_correction(new_correction, accumulator)

    train_network(batch, result, network_state)
  end

  defp train_sample(sample, network_state) do
    Forwarder.forward_for_activity(sample, network_state)
    |> Propagator.back_propagate(network_state)
  end
end
