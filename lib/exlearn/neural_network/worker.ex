defmodule ExLearn.NeuralNetwork.Worker do
  use GenServer

  alias ExLearn.NeuralNetwork.{Forwarder, Propagator}

  #----------------------------------------------------------------------------
  # Client API
  #----------------------------------------------------------------------------

  @spec get(any) :: any
  def get(worker) do
    GenServer.call(worker, :get, :infinity)
  end

  @spec work(:ask, map, any) :: any
  def work(:ask, network_state, worker) do
    GenServer.call(worker, {:ask, network_state}, :infinity)
  end

  @spec work(:train, map,  any) :: any
  def work(:train, network_state, worker) do
    GenServer.cast(worker, {:train, network_state})
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
      batch_size:     batch_size,
      data:           data_source,
      data_location:  data_location,
      learning_rate:  learning_rate
    } = configuration

    data = case data_location do
      :file   -> read_data(data_source)
      :memory -> data_source
    end

    chunks = Enum.chunk(data, batch_size, batch_size, [])

    batches = case chunks do
      []                  -> %{current: :not_set, remaining: :not_set }
      [current|remaining] -> %{current: current,  remaining: remaining}
    end

    state = %{
      batch_size:     batch_size,
      batches:        batches,
      data:           data,
      learning_rate:  learning_rate,
      result:         :no_data
    }

    {:ok, state}
  end

  @spec handle_call({}, any,  map) :: {}
  def handle_call(:get, _from,  state) do
    %{result: result} = state

    new_state = Map.put(state, :result, :no_data)

    {:reply, result, new_state}
  end

  @spec handle_call({}, any,  map) :: {}
  def handle_call({:ask, network_state}, _from,  state) do
    %{data: data} = state

    result = ask_network(data, network_state)

    {:reply, result, state}
  end

  @spec handle_cast({}, map) :: {}
  def handle_cast({:train, network_state}, state) do
    %{
      batch_size: batch_size,
      batches: %{
        current:   current,
        remaining: remaining
      },
      data: data
    } = state

    new_state = case current do
      :not_set ->
        Map.put(state, :result, :no_data)
      _ ->
        correction = train_network(current, network_state)

        case remaining do
          [] ->
            [new_current|new_remaining] = Enum.chunk(data, batch_size, batch_size, [])

            new_batches = %{current: new_current, remaining: new_remaining}

            Map.put(state, :batches, new_batches)
            |> Map.put(:result, {:done, correction})

          [new_current|new_remaining] ->
            new_batches = %{current: new_current, remaining: new_remaining}

            Map.put(state, :batches, new_batches)
            |> Map.put(:result, {:continue, correction})
        end
    end

    {:noreply, new_state}
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
