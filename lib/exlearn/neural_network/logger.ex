defmodule ExLearn.NeuralNetwork.Logger do
  use GenServer

  # Client API

  @spec get({}) :: {}
  def get(logger) do
    GenServer.call(logger, :get, :infinity)
  end

  @spec get({}) :: {}
  defp get(logger, timeout) do
    GenServer.call(logger, :get, timeout)
  end

  @spec log(String.t, {}) :: any
  def log(message, logger) do
    GenServer.cast(logger, {:log, message})
  end

  @spec start(map, {}) :: reference
  def start(args, options) do
    GenServer.start(__MODULE__, args, options)
  end

  @spec start_link(map, {}) :: reference
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  @spec stream(map) :: no_return
  def stream(logger) do
    stream_loop(logger, :infinity)
  end

  @spec stream(map, number) :: no_return
  def stream(logger, timeout) do
    stream_loop(logger, timeout)
  end

  @spec stream_async(map) :: any
  def stream_async(logger) do
    {:ok, pid} = Task.start(fn ->
      stream_loop(logger, :infinity)
    end)

    pid
  end

  @spec stream_async(map, number) :: any
  def stream_async(logger, timeout) do
    {:ok, pid} = Task.start(fn ->
      stream_loop(logger, timeout)
    end)

    pid
  end

  @spec stream_loop(map, number) :: no_return
  defp stream_loop(logger, timeout) do
    logs = get(logger, timeout)

    Enum.each(logs, fn(log) -> IO.puts log end)
    Process.sleep(500)

    stream_loop(logger, timeout)
  end

  # Server API

  @spec init([]) :: {}
  def init(initial_state) do
    {:ok, initial_state}
  end

  @spec handle_call(atom, any, list) :: tuple
  def handle_call(:get, _from, state) do
    {:reply, Enum.reverse(state), []}
  end

  @spec handle_cast(tuple, list) :: tuple
  def handle_cast({:log, message}, state) do
    {:noreply, [message|state]}
  end
end
