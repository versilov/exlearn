defmodule ExLearn.NeuralNetwork.Supervisor do
  alias ExLearn.NeuralNetwork.{Forwarder, Propagator, State}

  @spec start(map) :: pid
  def start(parameters) do
    state_server  = State.start(parameters)
    network_state = State.get_state(state_server)

    spawn fn -> network_loop(network_state) end
  end

  @spec network_loop(map) :: no_return
  defp network_loop(state) do
    receive do
      {:ask, input, caller} ->
        ask_network(input, state, caller)
        network_loop(state)
      {:test, batch, configuration, caller} ->
        result = test_network(batch, configuration, state)
        send caller, {:ok, result}
        network_loop(state)
      {:train, batch, configuration, caller} ->
        new_state = train_network(batch, configuration, state)
        send caller, :ok
        network_loop(new_state)
    end
  end

  defp ask_network(input, state, caller) do
    output = Forwarder.forward_for_output(input, state)

    send caller, {:ok, output}
  end

  defp test_network(batch, configuration, state) do
    outputs = Forwarder.forward_for_test(batch, state)

    %{network: %{objective: %{function: objective}}} = state
    %{data_size: data_size} = configuration

    targets = Enum.map(batch, fn ({_, target}) -> target end)

    costs = Enum.zip(targets, outputs)
      |> Enum.map(fn ({target, output}) -> objective.(target, output, data_size) end)

    {outputs, costs}
  end

  @spec train_network(list, map, map) :: map
  defp train_network(batch, configuration, state) do
    batch
    |> Forwarder.forward_for_activity(state)
    |> Propagator.back_propagate(configuration, state)
  end
end
