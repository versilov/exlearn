defmodule ExLearn.NeuralNetwork.Worker do
  @spec set_batch([{}], pid) :: atom
  def set_batch(new_batch, worker) do
    send worker, {:set, :batch, new_batch, self()}

    receive do
      message -> message
    end
  end

  @spec set_configuration([{}], pid) :: atom
  def set_configuration(new_configuration, worker) do
    send worker, {:set, :configuration, new_configuration, self()}

    receive do
      message -> message
    end
  end

  @spec set_network_state([{}], pid) :: atom
  def set_network_state(new_network_state, worker) do
    send worker, {:set, :network_state, new_network_state, self()}

    receive do
      message -> message
    end
  end

  @spec start([{}], map, map) :: pid
  def start(batch, configuration, network_state) do
    spawn fn -> worker_loop(batch, configuration, network_state) end
  end

  @spec worker_loop([{}], map, map) :: no_return
  defp worker_loop(batch, configuration, network_state) do
    receive do
      {:get, caller} ->
        send caller, :ok
        worker_loop(batch, configuration, network_state)
      {:set, :batch, new_batch, caller} ->
        send caller, :ok
        worker_loop(new_batch, configuration, network_state)
      {:set, :configuration, new_configuration, caller} ->
        send caller, :ok
        worker_loop(batch, new_configuration, network_state)
      {:set, :network_state, new_network_state, caller} ->
        send caller, :ok
        worker_loop(batch, configuration, new_network_state)
    end
  end
end
