defmodule ExLearn.NeuralNetwork.Accumulator do
  use GenServer

  alias ExLearn.NeuralNetwork.{Notification, Store}

  # Client API

  def load_data(data, configuration, accumulator) do
    GenServer.call(accumulator, {:load_data, data, configuration}, :infinity)
  end

  def load_network(accumulator) do
    GenServer.call(accumulator, :load_netwrok, :infinity)
  end

  def process_batch(accumulator) do
    GenServer.call(accumulator, :process_batch, :infinity)
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
      network_state: :not_set,
      notification:  notification,
      store:         store
    }

    {:ok, state}
  end

  def handle_call({:load_data, data, configuration}, state) do
    %{manager: manager} = state

    child_names = [{1, {:global, make_ref()}}]

    Enum.each(
      child_names,
      &Supervisor.start_child(
        manager,
        [[data, configuration], [name: elem(&1, 1)]]
      )
    )

    new_state = Map.put(state, :workers, child_names)

    {:reply, :ok, new_state}
  end

  def handle_call(:load_network, state) do
    %{
      notification: notification,
      store:        store
    } = state

    Notification.push("Loading netwrok", notification)
    network_state = Store.get_state(store)

    new_state = Map.put(state, :network_state, network_state)
    Notification.push("Finished loading netwrok", notification)

    {:reply, :ok, new_state}
  end

  def handle_call(:process_batch, state) do

    {:reply, :ok, state}
  end
end
