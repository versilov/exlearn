defmodule ExLearn.NeuralNetwork.Persistence do
  def save(network_state, name) do
    %{network: %{layers: layers}} = network_state

    biases  = Enum.map(layers, &Map.get(&1, :biases ))
    weights = Enum.map(layers, &Map.get(&1, :weights))

    data        = {1, {biases, weights}}
    binary_data = :erlang.term_to_binary(data)

    File.write(name, binary_data)
  end
end
