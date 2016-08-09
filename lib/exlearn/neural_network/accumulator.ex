defmodule ExLearn.NeuralNetwork.Accumulator do
  use GenServer

  alias ExLearn.NeuralNetwork.{Notification, Propagator, Store, Worker}

  # Client API

  def ask(data, accumulator) do
    GenServer.call(accumulator, {:ask, data}, :infinity)
  end

  def train(learning_parameters, accumulator) do
    GenServer.call(accumulator, {:train, learning_parameters}, :infinity)
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

  def handle_call({:ask, data}, _from, state) do
    result = ask_network(data, state)

    {:reply, result, state}
  end

  def handle_call({:train, learning_parameters}, _from,  state) do
    train_network(learning_parameters, state)

    {:reply, :ok, state}
  end

  # Internal functions

  defp ask_network(data, state) do
    %{manager: manager} = state

    network_state = Store.get(state)
    worker_name   = {:global, make_ref()}

    {:ok, _pid} = Supervisor.start_child(
      manager,
      [{data, []}, [name: worker_name]]
    )

    Worker.work(:ask, network_state, worker_name)
  end

  defp train_network(learning_parameters, state) do
    %{data: data, epochs: epochs} = learning_parameters
    network_state     = Store.get(state)
    workers           = start_workers(learning_parameters, state)

    Notification.push("Started training", state)
    train_for_epochs(workers, learning_parameters, network_state, state, epochs, 0)
    Notification.push("Finished training", state)

    :ok
  end

  defp start_workers(learning_parameters, state) do
    %{
      data:      data,
      data_size: data_size,
      workers:   workers_count
    } = learning_parameters
    %{manager: manager} = state

    workers = Enum.to_list(1..workers_count)
    |> Enum.map(fn(index) -> {index, {:global, make_ref()}} end)

    chunk_size = trunc(data_size / workers_count)
    chunks     = Enum.chunk(data, chunk_size)

    Enum.zip(workers, chunks)
    |> Enum.each(fn({worker, chunk}) ->
      Supervisor.start_child(
        manager,
        [{chunk, learning_parameters}, [name: elem(worker, 1)]]
      )
    end)

    workers
  end

  defp train_for_epochs(_, _, _, _, epochs, current_epoch)
      when epochs == current_epoch, do: :ok
  defp train_for_epochs(workers, configuration, network_state, state, epochs, current_epoch) do
    Notification.push("Epoch: #{current_epoch + 1}", state)

    Enum.map(workers, &prepare_worker/1)
    |> Enum.map(&Task.await(&1, :infinity))

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

  defp prepare_worker({_index, worker}) do
    Task.async(fn -> Worker.prepare(worker) end)
  end

  defp train_worker(worker, network_state) do
    {
      worker,
      Task.async(fn ->
        Worker.work(:train, network_state, elem(worker, 1))
      end)
    }
  end

  defp await_worker(task_data) do
    {worker, task} = task_data

    result = Task.await(task, :infinity)

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
    corrections = Enum.map(worker_data, fn(data) ->
      {_, {_, correction}} = data

      correction
    end)

    Enum.reduce(corrections, &Propagator.reduce_correction/2)
  end
end
