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

  def train(data, parameters, accumulator) do
    GenServer.call(accumulator, {:train, data, parameters}, :infinity)
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
  def handle_call({:train, data, parameters}, _from,  state) do
    train_network(data, parameters, state)

    {:reply, :ok, state}
  end

  #----------------------------------------------------------------------------
  # Internal functions
  #----------------------------------------------------------------------------

  defp ask_network(data, state) do
    %{manager: manager} = state

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
    configuration = %{data: %{location: data_location, source: data_list}}

    {:ok, _pid} = Supervisor.start_child(
      manager,
      [configuration, [name: worker_name]]
    )

    Worker.predict(network_state, worker_name)
    Worker.get(worker_name)
  end

  #----------------------------------------------------------------------------
  # Network training
  #----------------------------------------------------------------------------

  @spec train_network(map, map, map) :: :ok
  defp train_network(data, parameters, state) do
    %{epochs: epochs} = parameters

    network_state = Store.get(state)
    workers       = start_workers(data, parameters, state)

    Notification.push("Started training", state)
    train_for_epochs(workers, network_state, state, epochs, 0)
    Notification.push("Finished training", state)
  end

  @spec start_workers(any, any, map) :: list
  defp start_workers(data, parameters, state) do
    %{workers: maximum_workers} = parameters

    initial_configuration = prepare_learning_configuration(parameters)

    prepare_workers_configuration(initial_configuration, data, maximum_workers)
    |> prepare_workers(maximum_workers, state)
  end

  defp prepare_learning_configuration(parameters) do
    regularization = Regularization.determine(
      Map.get(parameters, :regularization, :none)
    )

    Map.put(parameters, :regularization, regularization)
    |> Map.delete(:workers)
  end

  defp prepare_workers_configuration(configuration, data, maximum_workers) do
    training   = Map.get(data, :training,   :no_data)
    validation = Map.get(data, :validation, :no_data)
    test       = Map.get(data, :test,       :no_data)

    training_chunks   = extract_chunks(training,   maximum_workers)
    validation_chunks = extract_chunks(validation, maximum_workers)
    test_chunks       = extract_chunks(test,       maximum_workers)

    configuation_from_chunks(
      configuration,
      training_chunks,
      validation_chunks,
      test_chunks
    )
  end

  defp configuation_from_chunks(initial, training, validation, test) do
    []
    |> add_data_to_configuration(training,   initial, :training,   [])
    |> add_data_to_configuration(validation, initial, :validation, [])
    |> add_data_to_configuration(test,       initial, :test,       [])
  end

  defp add_data_to_configuration(configuration, {_, []}, _, _, accumulator) do
    configuration ++ accumulator
  end

  defp add_data_to_configuration([], {location, [b|chunks]}, initial, key, accumulator) do
    data = %{
      data:          b,
      data_location: location
    }

    new_configuration = Map.put(initial, key, data)
    new_accumulator   = [new_configuration|accumulator]

    add_data_to_configuration([], {location, chunks}, initial, key, new_accumulator)
  end

  defp add_data_to_configuration([a|configuration], {location, [b|chunks]}, initial, key, accumulator) do
    data     = Map.get(a, key, %{})
    new_data = Map.put(data, :data, b)
    |> Map.put(:data_location, location)

    new_configuration = Map.put(a, key, new_data)
    new_accumulator   = [new_configuration|accumulator]

    add_data_to_configuration(configuration, {location, chunks}, initial, key, new_accumulator)
  end

  defp extract_chunks(:no_data, worker_count), do: {:memory, []}
  defp extract_chunks(data,     worker_count)  do
    %{
      data:      data_source,
      data_size: data_size
    } = data

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

    chunks = split_in_chunks(data_source, chunk_size)

    {data_location, chunks}
  end

  defp prepare_workers(worker_configurations, maximum_workers, state) do
    %{manager: manager} = state

    workers = Enum.to_list(1..maximum_workers)
    |> Enum.map(fn(index) -> {index, {:global, make_ref()}} end)

    Enum.zip(workers, worker_configurations)
    |> Enum.each(fn({worker, configuration}) ->
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

  defp train_for_epochs(_, _, _, epochs, current_epoch)
  when epochs == current_epoch, do: :ok

  defp train_for_epochs(workers, network_state, state, epochs, current_epoch) do
    Notification.push("Epoch: #{current_epoch + 1}", state)

    new_network_state = train_each_batch(workers, network_state, state)

    train_for_epochs(workers, new_network_state, state, epochs, current_epoch + 1)
  end

  defp train_each_batch([], network_state, _) do
    network_state
  end

  defp train_each_batch(workers, network_state, state) do
    {remaining_workers, correction} = Enum.map(workers, &train_worker(&1, network_state))
    |> Enum.map(&await_worker/1)
    |> accumulate_correction

    new_network_state = Propagator.apply_changes(correction, network_state)

    Store.set(new_network_state, state)

    train_each_batch(remaining_workers, new_network_state, state)
  end

  defp train_worker(worker, network_state) do
    Worker.train(network_state, elem(worker, 1))

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
