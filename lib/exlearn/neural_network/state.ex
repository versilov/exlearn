defmodule ExLearn.NeuralNetwork.State do
  alias ExLearn.NeuralNetwork.{Builder}

  @spec start(map) :: pid
  def start(parameters) do
    network_state = Builder.initialize(parameters)

    spawn fn -> state_loop(network_state) end
  end

  @spec get_state(pid) :: map
  def get_state(server) do
    send server, {:get, self()}

    receive do
      {:ok, state} -> state
    end
  end

  @spec state_loop(map) :: no_return
  defp state_loop(state) do
    receive do
      {:get, caller} ->
        send caller, {:ok, state}
        state_loop(state)
    end
  end
end
