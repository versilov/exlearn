defmodule BrainTonic.NeuralNetwork.Builder do
  @moduledoc """
  Build functionality
  """

  @doc """
  Initializez a neural network with the given setup
  """
  @spec initialize(map) :: map
  def initialize(setup) do
    layers = setup[:hidden_layers_number]
    hidden_sizes = setup[:hidden_layers_sizes]
    output_size = setup[:output_layer_size]
    column_sizes = hidden_sizes ++ [output_size]
    weights = initialize_matrix(column_sizes)
    biases = initialize_list(layers)
    %{
      weights: weights,
      biases: biases,
      activations: []
    }
  end

  @spec initialize_matrix([pos_integer,...]) :: list
  defp initialize_matrix(column_sizes) do
    Enum.reduce(column_sizes, [], fn (size, total) ->
      total ++ initialize_list(size)
    end)
  end

  @spec initialize_list(pos_integer) :: list
  defp initialize_list(size) do
    Stream.unfold(size, fn
      0 -> nil
      n -> {:rand.uniform, n - 1}
    end)
    |> Enum.to_list
  end
end
