defmodule ExLearn.NeuralNetwork.Accumulator do
  use GenServer

  alias ExLearn.NeuralNetwork.{
    Notification, Propagator, Regularization, Store, Worker
  }

  #----------------------------------------------------------------------------
  # Client API
  #----------------------------------------------------------------------------

  @spec ask(map, map) :: list
  def ask(data, accumulator) do
    GenServer.call(accumulator, {:ask, data}, :infinity)
  end

  def train(learning_parameters, accumulator) do
    GenServer.call(accumulator, {:train, learning_parameters}, :infinity)
  end

  @spec start(list(tuple), map) :: {}
  def start(args, options) do
    GenServer.start( __MODULE__, args, options)
  end

  @spec start_link([{}], map) :: {}
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  #----------------------------------------------------------------------------
  # Server API
  #----------------------------------------------------------------------------

  @spec init(any) :: {:ok, map}
  def init(names) do
    %{
      manager:      manager,
      notification: notification,
      store:        store
    } = names

    state = %{
      manager:       manager,
      notification:  notification,
      store:         store
    }

    {:ok, state}
  end

  @spec handle_call(tuple, any, map) :: {:reply, list, map}
  def handle_call({:ask, data}, _from, state) do
    result = ask_network(data, state)

    {:reply, result, state}
  end

  @spec handle_call(tuple, any, map) :: {:reply, :ok, map}
  def handle_call({:train, learning_parameters}, _from,  state) do
    train_network(learning_parameters, state)

    {:reply, :ok, state}
  end

  #----------------------------------------------------------------------------
  # Internal functions
  #----------------------------------------------------------------------------

  defp ask_network(data, state) do
    %{manager: manager} = state

    batch_size = case data do
      path when is_bitstring(path) ->
        files = Path.wildcard(path)

        trunc(length(files))
      _ ->
        length(data)
    end

    data_list = case data do
      path when is_bitstring(path) -> Path.wildcard(path)
      _  -> data
    end

    data_location = case data do
      path when is_bitstring(path) -> :file
      _                            -> :memory
    end

    network_state = Store.get(state)
    worker_name   = {:global, make_ref()}
    configuration = %{
      batch_size:    batch_size,
      data:          data_list,
      data_location: data_location,
      learning_rate: :not_needed
    }

    {:ok, _pid} = Supervisor.start_child(
      manager,
      [configuration, [name: worker_name]]
    )

    Worker.work(:ask, network_state, worker_name)
  end

  @spec train_network(map, map) :: :ok
  defp train_network(learning_parameters, state) do
    %{
      training: training_parameters,
      workers:  worker_count
    } = learning_parameters

    %{
      epochs:         epochs,
      regularization: regularization
    } = training_parameters

    regularization_function = Regularization.determine(regularization)

    new_training_parameters = Map.put(
      training_parameters,
      :regularization,
      regularization_function
    )

    network_state = Store.get(state)
    workers       = start_workers(worker_count, new_training_parameters, state)

    Notification.push("Started training", state)
    train_for_epochs(workers, new_training_parameters, network_state, state, epochs, 0)
    Notification.push("Finished training", state)

    :ok
  end

  @spec start_workers(any, any, map) :: list
  defp start_workers(worker_count, training_parameters, state) do
    %{
      batch_size:    batch_size,
      data:          data_source,
      data_size:     data_size,
      learning_rate: learning_rate
    } = training_parameters

    %{manager: manager} = state

    chunk_size = case data_source do
      path when is_bitstring(path) ->
        files = Path.wildcard(path)

        trunc(Float.ceil(length(files) / worker_count))
      _ ->
        trunc(Float.ceil(data_size / worker_count))
    end

    data_location = case data_source do
      path when is_bitstring(path) -> :file
      _                            -> :memory
    end

    chunks           = split_in_chunks(data_source, chunk_size)
    workers_to_start = length(chunks)

    workers = Enum.to_list(1..workers_to_start)
    |> Enum.map(fn(index) -> {index, {:global, make_ref()}} end)

    Enum.zip(workers, chunks) |> Enum.each(fn({worker, chunk}) ->
      configuration = %{
        batch_size:    trunc(Float.ceil(batch_size / workers_to_start)),
        data:          chunk,
        data_location: data_location,
        learning_rate: learning_rate
      }

      Supervisor.start_child(manager, [configuration, [name: elem(worker, 1)]])
    end)

    workers
  end

  defp split_in_chunks(data_source, chunk_size) do
    data_list = case data_source do
      path when is_bitstring(path) -> Path.wildcard(path)
      _  -> data_source
    end

    Enum.chunk(data_list, chunk_size, chunk_size, [])
  end

  defp train_for_epochs(_, _, _, _, epochs, current_epoch)
  when epochs == current_epoch, do: :ok

  defp train_for_epochs(workers, configuration, network_state, state, epochs, current_epoch) do
    Notification.push("Epoch: #{current_epoch + 1}", state)

    new_network_state = train_each_batch(workers, configuration, network_state, state)

    train_for_epochs(workers, configuration, new_network_state, state, epochs, current_epoch + 1)
  end

  defp train_each_batch([], _, network_state, _) do
    network_state
  end

  defp train_each_batch(workers, configuration, network_state, state) do
    {remaining_workers, correction} = Enum.map(workers, &train_worker(&1, network_state))
    |> Enum.map(&await_worker/1)
    |> accumulate_correction

    new_network_state = Propagator.apply_changes(correction, configuration, network_state)

    Store.set(new_network_state, state)

    train_each_batch(remaining_workers, configuration, new_network_state, state)
  end

  defp train_worker(worker, network_state) do
    Worker.work(:train, network_state, elem(worker, 1))

    worker
  end

  defp await_worker(worker) do
    result = Worker.get(elem(worker, 1))

    {worker, result}
  end

  defp accumulate_correction(worker_data) do
    workers    = filter_workers(worker_data, [])
    correction = reduce_correction(worker_data)

    {workers, correction}
  end

  defp filter_workers([], workers) do
    workers
  end

  defp filter_workers([worker_data|rest], workers) do
    case worker_data do
      {_worker, {:done,     _}} -> filter_workers(rest, workers)
      {worker,  {:continue, _}} -> filter_workers(rest, [worker|workers])
    end
  end

  defp reduce_correction(worker_data) do
    corrections = Enum.reduce(worker_data, [], fn(data, accumulator) ->
      {_, {_, correction}} = data

      [correction|accumulator]
    end)

    Enum.reduce(corrections, &Propagator.reduce_correction/2)
  end
end
