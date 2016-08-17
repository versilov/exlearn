defmodule ExLearn.NeuralNetwork.Builder do
  @moduledoc """
  Neural Network creation and initialization functionality.

  This module is NOT part of the public API.
  """

  alias ExLearn.{Activation, Distribution, Matrix, Objective}
  alias ExLearn.NeuralNetwork.Presentation

  @doc """
  Creates a neural network with the given structure.
  """
  @spec create(map) :: map
  def create(structure) do
    %{
      layers: %{
        hidden: hidden_layers,
        input:  input_layer,
        output: output_layer
      },
      objective: objective_setup
    } = structure

    presentation = case Map.get(structure, :presentation) do
      nil   -> Presentation.determine(:identity)
      other -> Presentation.determine(other)
    end

    layer_config = [input_layer] ++ hidden_layers ++ [output_layer]
    objective    = Objective.determine(objective_setup, output_layer)
    layers       = create_layers(layer_config, [])

    %{
      network: %{
        layers:       layers,
        objective:    objective,
        presentation: presentation
      },
      structure: structure
    }
  end

  defp create_layers([_|[]], accumulator) do
    Enum.reverse(accumulator)
  end

  defp create_layers([first, second|rest], accumulator) do
    %{size: rows} = first

    %{
      activity: function_setup,
      name:     name,
      size:     columns,
    } = second

    activity = Activation.determine(function_setup)

    layer = %{
      activity: activity,
      biases:   :not_initialized,
      columns:  columns,
      name:     name,
      rows:     rows,
      weights:  :not_initialized,
    }

    create_layers([second|rest], [layer|accumulator])
  end

  @doc """
  Initializez a neural network with the given setup.
  """
  @spec initialize(map, map) :: map
  def initialize(network_state, parameters) do
    %{network: network = %{layers: layers}} = network_state

    random_function = Distribution.determine(parameters)
    new_layers      = initialize_layers(layers, random_function, [])

    new_network = Map.put(network, :layers, new_layers)
    Map.put(network_state, :network, new_network)
  end

  defp initialize_layers([], _, accumulator) do
    Enum.reverse(accumulator)
  end

  defp initialize_layers([layer|rest], random_function, accumulator) do
    %{columns: columns, rows: rows} = layer
    biases  = Matrix.new(1,    columns, random_function)
    weights = Matrix.new(rows, columns, random_function)

    new_layer = layer
    |> Map.put(:biases,  biases)
    |> Map.put(:weights, weights)

    initialize_layers(rest, random_function, [new_layer|accumulator])
  end
end
