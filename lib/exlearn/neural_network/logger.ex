defmodule ExLearn.NeuralNetwork.Logger do
  use GenServer

  # Client API

  @spec start(map, {}) :: reference
  def start(args, options) do
    GenServer.start(__MODULE__, args, options)
  end

  @spec start_link(map, {}) :: reference
  def start_link(args, options) do
    GenServer.start_link(__MODULE__, args, options)
  end

  # Server API

  @spec init([]) :: {}
  def init(initial_state) do
    {:ok, initial_state}
  end
end
