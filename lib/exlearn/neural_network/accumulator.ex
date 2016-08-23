defmodule ExLearn.NeuralNetwork.Accumulator do
  use GenServer

  alias ExLearn.NeuralNetwork.{
    Notification, Propagator, Regularization, Store, Worker
  }

  #----------------------------------------------------------------------------
  # Client API
  #----------------------------------------------------------------------------

  @spec start_link([{}], map) :: {}
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  @spec get(any) :: any
  def get(accumulator) do
    GenServer.call(accumulator, :get, :infinity)
  end

  @spec process(map, map, any) :: any
  def process(data, parameters, accumulator) do
    GenServer.cast(accumulator, {:process, data, parameters})
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
      manager:      manager,
      notification: notification,
      store:        store,
      result:       :no_data
    }

    {:ok, state}
  end

  @spec handle_call(tuple, any,  map) :: {:reply, list, map}
  def handle_call(:get, _from,  state) do
    %{result: result} = state

    new_state = Map.put(state, :result, :no_data)

    {:reply, result, new_state}
  end

  @spec handle_cast(tuple, map) :: {:reply, map}
  def handle_cast({:process, data, parameters}, state) do
    result = process_input(data, parameters, state)

    new_state = Map.put(state, :result, result)

    {:noreply, new_state}
  end

  #----------------------------------------------------------------------------
  # Internal functions
  #----------------------------------------------------------------------------

  @spec process_input(map, map, map) :: any
  defp process_input(data, parameters, state) do
    maybe_process_training_and_validation(data, parameters, state)
    maybe_process_testing(data, parameters, state)
    maybe_process_prediction(data, state)
  end

  #----------------------------------------------------------------------------
  # Training and Validation
  #----------------------------------------------------------------------------

  defp maybe_process_training_and_validation(data, parameters, state) do
    case Map.get(data, :train) do
      nil -> :ok
      _   -> process_training_and_validation(data, parameters, state)
    end
  end

  defp process_training_and_validation(data, parameters, state) do
    %{epochs: epochs} = parameters

    network_state       = Store.get(state)
    workers             = start_workers(data, parameters, state)
    training_parameters = prepare_training_parameters(data, parameters)

    Notification.push("Started training",  state)
    train_for_epochs(workers, training_parameters, network_state, state, epochs, 0)
    Notification.push("Finished training", state)
  end

  #----------------------------------------------------------------------------
  # Testing
  #----------------------------------------------------------------------------

  defp maybe_process_testing(data, parameters, state) do
    case Map.get(data, :test) do
      nil -> :ok
      _   -> process_testing(data, parameters, state)
    end
  end

  defp process_testing(_data, _parameters, _state) do
  end

  #----------------------------------------------------------------------------
  # Prediction
  #----------------------------------------------------------------------------

  defp maybe_process_prediction(data, state) do
    case Map.get(data, :predict) do
      nil             -> :ok
      prediction_data -> process_prediction(prediction_data, state)
    end
  end

  defp process_prediction(data, state) do
    %{manager: manager    } = state
    %{data:    data_source} = data

    data_list = case data_source do
      path when is_bitstring(path) -> Path.wildcard(path)
      _  -> data_source
    end

    data_location = case data_source do
      path when is_bitstring(path) -> :file
      _                            -> :memory
    end

    network_state = Store.get(state)
    worker_name   = {:global, make_ref()}
    setup         = %{data: %{location: data_location, source: data_list}}

    {:ok, _pid} = Supervisor.start_child(
      manager,
      [setup, [name: worker_name]]
    )

    Worker.predict(network_state, worker_name)
    Worker.get(worker_name)
  end

  #----------------------------------------------------------------------------
  # Network training
  #----------------------------------------------------------------------------

  @spec start_workers(any, any, map) :: list
  defp start_workers(data, parameters, state) do
    %{workers: maximum_workers} = parameters

    initial_configuration = prepare_training_configuration(parameters)

    prepare_worker_setup(data, :train, maximum_workers)
    |> start_workers(initial_configuration, maximum_workers, state)
  end

  defp prepare_training_configuration(parameters) do
    case Map.get(parameters, :batch_size) do
      nil        -> %{}
      batch_size -> %{batch_size: batch_size}
    end
  end

  defp prepare_worker_setup(data, type, maximum_workers) do
    data_source = Map.get(data, type, :no_data)

    extract_chunks(data_source, maximum_workers)
  end

  defp extract_chunks(:no_data, _worker_count) do
    %{location: :memory, sources: []}
  end

  defp extract_chunks(data,  worker_count) do
    %{data: data_source, size: data_size} = data

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

    %{location: data_location, sources: chunks}
  end

  defp start_workers(data, configuration, maximum_workers, state) do
    %{manager: manager} = state
    %{
      location: location,
      sources:  sources
    } = data

    workers = Enum.to_list(1..maximum_workers)
    |> Enum.map(fn(index) -> {index, {:global, make_ref()}} end)


    necessary_workers = Enum.map(sources, fn(source) ->
      %{
        data: %{location: location, source: source},
        configuration: configuration
      }
    end)
    |> Enum.zip(workers)

    Enum.each(necessary_workers, fn({setup, worker}) ->
      {:ok, _pid} = Supervisor.start_child(
        manager,
        [setup, [name: elem(worker, 1)]]
      )
    end)

    Enum.map(necessary_workers, fn({_setup, worker}) -> worker end)
  end

  defp split_in_chunks(data_source, chunk_size) do
    data_list = case data_source do
      path when is_bitstring(path) -> Path.wildcard(path)
      _  -> data_source
    end

    Enum.chunk(data_list, chunk_size, chunk_size, [])
  end

  defp prepare_training_parameters(data, parameters) do
    %{train: %{size: data_size}} = data
    %{
      batch_size:    batch_size,
      learning_rate: learning_rate
    } = parameters

    regularization_setup = Map.get(parameters, :regularization, :none)
    regularization = Regularization.determine(regularization_setup)

    %{
      batch_size:     batch_size,
      data_size:      data_size,
      learning_rate:  learning_rate,
      regularization: regularization
    }
  end

  defp train_for_epochs(_, _, _, _, epochs, current_epoch)
  when epochs == current_epoch, do: :ok

  defp train_for_epochs(workers, parameters, network_state, state, epochs, current_epoch) do
    Notification.push("Epoch: #{current_epoch + 1}", state)

    new_network_state = train_each_batch(workers, parameters, network_state, state)

    train_for_epochs(workers, parameters, new_network_state, state, epochs, current_epoch + 1)
  end

  defp train_each_batch([], _parameters, network_state, _) do
    network_state
  end

  defp train_each_batch(workers, parameters, network_state, state) do
    {remaining_workers, correction} = Enum.map(workers, &train_worker(&1, network_state))
    |> Enum.map(&await_worker/1)
    |> accumulate_correction

    new_network_state = Propagator.apply_changes(correction, parameters, network_state)

    Store.set(new_network_state, state)

    train_each_batch(remaining_workers, parameters, new_network_state, state)
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
