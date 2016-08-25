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
      nil -> :no_data
      _   -> process_training_and_validation(data, parameters, state)
    end
  end

  defp process_training_and_validation(data, parameters, state) do
    training_data   = Map.get(data, :train)
    validation_data = Map.get(data, :validate, %{data: [], size: 1})

    training_workers   = start_workers(training_data,   parameters, state)
    validation_workers = start_workers(validation_data, parameters, state)

    train_and_validate(training_workers, validation_workers, data, parameters, state)
  end

  defp train_and_validate(training_workers, validation_workers, data, parameters, state) do
    %{epochs: epochs} = parameters

    network_state       = Store.get(state)
    training_parameters = prepare_training_parameters(data, parameters)

    Notification.push("Started training", state)

    Enum.to_list(1..epochs)
    |> Enum.reduce(network_state, fn(epoch, current_network_state) ->
      Notification.push("Epoch: #{epoch}", state)

      new_network_state = train_each_batch(
        training_workers,
        training_parameters,
        current_network_state,
        state,
        0
      )

      process_training_accuracy(
        training_workers,
        new_network_state,
        data,
        state
      )
      process_validation_accuracy(
        validation_workers,
        new_network_state,
        data,
        state
      )

      new_network_state
    end)
  end

  defp process_training_accuracy([], _, _, _), do: :ok
  defp process_training_accuracy(workers, network_state, data, state) do
    %{train: %{size: size}} = data

    %{
      error:    error,
      matching: matching,
      percent:  percent
    } = process_accuracy(workers, network_state, size)

    Notification.push(
      "Training accuracy: #{matching}/#{size} (#{percent}%) Error: #{error}",
      state
    )
  end

  defp process_validation_accuracy([], _, _, _), do: :ok
  defp process_validation_accuracy(workers, network_state, data, state) do
    %{validate: %{size: size}} = data

    %{
      error:    error,
      matching: matching,
      percent:  percent
    } = process_accuracy(workers, network_state, size)

    Notification.push(
      "Validation accuracy: #{matching}/#{size} (#{percent}%) Error: #{error}",
      state
    )
  end

  #----------------------------------------------------------------------------
  # Testing
  #----------------------------------------------------------------------------

  defp maybe_process_testing(data, parameters, state) do
    case Map.get(data, :test) do
      nil -> :no_data
      _   -> process_testing(data, parameters, state)
    end
  end

  defp process_testing(data, parameters, state) do
    network_state = Store.get(state)
    test_data       = Map.get(data, :test)
    test_parameters = %{workers: Map.get(parameters, :workers, 1)}

    workers = start_workers(test_data, test_parameters, state)

    Notification.push("Started testing", state)
    test_data(workers, network_state, data, state)
  end

  defp test_data([], _, _, _), do: :ok
  defp test_data(workers, network_state, data, state)  do
    %{test: %{size: size}} = data

    %{
      error:    error,
      matching: matching,
      percent:  percent
    } = process_accuracy(workers, network_state, size)

    Notification.push(
      "Test accuracy: #{matching}/#{size} (#{percent}%) Error: #{error}",
      state
    )
  end

  defp process_accuracy(workers, network_state, data_size) do
    result = Enum.map(workers, fn(worker) ->
      {_id, worker_name} = worker

      Worker.test(network_state, worker_name)

      worker
    end)
    |> Enum.map(fn(worker) ->
      {_id, worker_name} = worker

      Worker.get(worker_name)
    end)
    |> Enum.filter(&is_tuple/1)

    error    = Enum.reduce(result, 0, fn({e, _}, acc) -> acc + e end)
    matching = Enum.reduce(result, 0, fn({_, m}, acc) -> acc + m end)
    percent  = matching / data_size * 100

    %{
      error:    error / data_size,
      matching: matching,
      percent:  percent
    }
  end

  #----------------------------------------------------------------------------
  # Prediction
  #----------------------------------------------------------------------------

  defp maybe_process_prediction(data, state) do
    case Map.get(data, :predict) do
      nil             -> :no_data
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

    configuration = case Map.get(parameters, :batch_size) do
      nil        -> %{}
      batch_size -> %{batch_size: batch_size}
    end

    data
    |> extract_chunks(maximum_workers)
    |> start_workers(configuration, maximum_workers, state)
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

  defp train_each_batch([], _parameters, network_state, _, _) do
    network_state
  end
  defp train_each_batch(workers, parameters, network_state, state, current_batch) do
    {remaining_workers, correction} = Enum.map(workers, &train_worker(&1, network_state))
    |> Enum.map(&await_worker/1)
    |> accumulate_correction

    new_network_state = case correction do
      [] -> network_state
      _  -> Propagator.apply_changes(correction, parameters, network_state)
    end

    Store.set(new_network_state, state)

    train_each_batch(remaining_workers, parameters, new_network_state, state, current_batch + 1)
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

  defp filter_workers([],                 workers), do: workers
  defp filter_workers([worker_data|rest], workers)  do
    case worker_data do
      {_worker, :no_data      } -> filter_workers(rest, workers)
      {_worker, {:done,     _}} -> filter_workers(rest, workers)
      {worker,  {:continue, _}} -> filter_workers(rest, [worker|workers])
    end
  end

  defp reduce_correction(worker_data) do
    corrections = Enum.reduce(worker_data, [], fn
      ({_, :no_data       }, accumulator) -> accumulator
      ({_, {_, correction}}, accumulator) -> [correction|accumulator]
    end)

    case corrections do
      [] -> []
      _  -> Enum.reduce(corrections, &Propagator.reduce_correction/2)
    end
  end
end
