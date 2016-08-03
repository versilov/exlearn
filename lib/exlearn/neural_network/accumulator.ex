defmodule ExLearn.NeuralNetwork.Accumulator do
  use GenServer

  alias ExLearn.NeuralNetwork.{Notification, Store, Worker}

  # Client API

  def ask(data, accumulator) do
    GenServer.call(accumulator, {:ask, data}, :infinity)
  end

  def train(data, configuration, accumulator) do
    GenServer.call(accumulator, {:train, data, configuration}, :infinity)
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
      notification:  notification,
      store:         store
    }

    {:ok, state}
  end

  def handle_call({:ask, data}, state) do
    {:reply, :ok, state}
  end

  def handle_call({:train, data, configuration}, state) do
    train_network(data, configuration, state)

    {:reply, :ok, state}
  end

  # Internal functions

  defp train_network(data, configuration, state) do
    %{epochs: epochs} = configuration
    netwrok_state     = Store.get(state)
    workers           = start_workers(data, configuration, state)

    Notification.push("Started training", state)
    train_for_epochs(workers, network_state, state, epochs, 0)
    Notification.push("Finished training", state)

    :ok
  end

  defp start_workers(data, configuration, state) do
    %{workers: workers} = configuration
    %{manager: manager} = state

    workers = Enum.to_list(1..workers)
    |> Enum.map(fn(index) -> {index, {:global, make_ref()}})

    Enum.each(
      workers,
      &Supervisor.start_child(
        manager,
        [[data, configuration], [name: elem(&1, 1)]]
      )
    )

    workers
  end

  defp train_for_epochs(workers, network_state, state, epochs, ^epochs), do: :ok
  defp train_for_epochs(workers, network_state, state, epochs, current_epoch) do
    Notification.push("Epoch: #{current_epoch + 1}", state)

    Enum.map(workers, &prepare_worker/1)
    |> Enum.map(&Task.await(&1, :infinity))

    new_network_state = train_each_batch(workers, network_state, state)

    train_for_epochs(workers, new_network_state, state, epochs, current_epoch + 1)
  end

  defp train_each_batch([], network_state, state) do
    network_state
  end

  defp train_each_batch(workers, network_state, state) do
    %{configuration: configuration} = state

    {remaining_workers, correction} = Enum.map(workers, &train_worker(&1, network_state))
    |> Enum.map(&await_worker/1)
    |> accumulate_correction

    new_network_state = Propagator.apply_changes(correction, configuration, network_state)

    Store.set(new_network_state, state)

    train_each_batch(remaining_workers, new_network_state, state)
  end

  defp prepare_worker({_index, worker}) do
    Task.async(&Worker.prepare(worker))
  end

  defp train_worker(worker, network_state) do
    {worker, Task.async(&Worker.work(:train, network_state, worker))}
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
      {_worker, {_, :done}}     -> filter_workers(rest, workers)
      {worker,  {_, :continue}} -> filter_workers(rest, [worker|workers])
    end
  end

  defp reduce_correction(worker_data) do
    corrections = Enum.map(worker_data, fn(data) ->
      {_, {correction, _}} = data

      correction
    end)

    Enum.reduce(corrections, &Worker.accumulate_correction/2)
  end
end
