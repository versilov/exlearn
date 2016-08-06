defmodule ExLearn.NeuralNetwork.Persistence do
  alias ExLearn.NeuralNetwork.Store

  def save(network_state, name) do
    %{network: %{layers: layers}} = network_state

    biases  = Enum.map(layers, &Map.get(&1, :biases ))
    weights = Enum.map(layers, &Map.get(&1, :weights))

    data        = {1, {biases, weights}}
    binary_data = :erlang.term_to_binary(data)

    File.write(name, binary_data)
  end

  def load(name, network) do
    {:ok, binary_data } = File.read(name)
    {1,   network_data} = :erlang.binary_to_term(binary_data)

    network_data
  end
end
