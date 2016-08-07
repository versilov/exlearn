defmodule ExLearn.NeuralNetwork.Persistence do
  alias ExLearn.Util

  def load(network_state, name) do
    {:ok, binary    } = File.read(name)
    {1,   layer_data} = :erlang.binary_to_term(binary)

    merge(layer_data, network_state)
  end

  def save(network_state, name) do
    %{network: %{layers: layers}} = network_state

    layer_data = Enum.map(layers, fn(layer) ->
      %{}
      |> Map.put(:biases,  Map.get(layer, :biases ))
      |> Map.put(:weights, Map.get(layer, :weights))
    end)

    data   = {1, layer_data}
    binary = :erlang.term_to_binary(data)

    File.write(name, binary)
  end

  defp merge(layer_data, network_state) do
    %{network: network = %{layers: old_layers}} = network_state

    new_layers  = Util.zip_map(old_layers, layer_data, &Map.merge/2)
    new_network = Map.put(network, :layers, new_layers)

    Map.put(network_state, :network, new_network)
  end
end
