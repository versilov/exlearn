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
    %{manager: manager} = state

    workers = [{1, {:global, make_ref()}}]

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

    workers
    |> Enum.map(&prepare_worker(&1, network_state))
    |> Enum.map(&Task.await(&1, :infinity))
    |> Enum.map(&train_worker(&1, network_state))
    |> Enum.map(&Task.await(&1, :infinity))
    |> accumulate_corrections
    |> apply_correction
    |> set_worker_state

    train_for_epochs(workers, state, epochs, current_epoch + 1)
  end

  defp prepare_worker(worker, network_state) do
    Task.async(fn -> Worker.prepare(netwrok_state, worker) end)
  end

  defp train_worker(worker, network_state) do
    Task.async(fn -> Worker.work(:train, worker) end)
  end

  defp accumulate_corrections do
  end

  defp apply_correction do
  end

  defp set_worker_state do
  end
end
