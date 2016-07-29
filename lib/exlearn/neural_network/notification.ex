defmodule ExLearn.NeuralNetwork.Notification do
  use GenServer

  # Client API

  @spec done(any) :: {}
  def done(logger) do
    GenServer.cast(logger, :done)
  end

  @spec pop({}) :: {}
  def pop(logger) do
    GenServer.call(logger, :pop, :infinity)
  end

  @spec push(String.t, {}) :: any
  def push(message, logger) do
    GenServer.cast(logger, {:push, message})
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
    Task.async(fn -> stream_loop(logger) end)
  end

  @spec stream_loop(map) :: no_return
  defp stream_loop(logger) do
    logs = pop(logger)

    case reduce_logs(logs) do
      :done     -> :ok
      _not_done ->
        Process.sleep(500)

        stream_loop(logger)
    end
  end

  defp reduce_logs([]), do: :ok
  defp reduce_logs([log|logs]) do
    case log do
      :done               -> :done
      {:message, message} ->
        IO.puts(message)

        reduce_logs(logs)
    end
  end

  # Server API

  @spec init([]) :: {}
  def init(initial_state) do
    {:ok, initial_state}
  end

  @spec handle_call(atom, any, list) :: tuple
  def handle_call(:pop, _from, state) do
    {:reply, Enum.reverse(state), []}
  end

  @spec handle_cast(tuple, list) :: tuple
  def handle_cast(:done, state) do
    {:noreply, [:done|state]}
  end

  @spec handle_cast(tuple, list) :: tuple
  def handle_cast({:push, message}, state) do
    {:noreply, [{:message, message}|state]}
  end
end
