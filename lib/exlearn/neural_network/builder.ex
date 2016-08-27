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

    presentation_setup = Map.get(structure, :presentation, :raw)
    presentation       = Presentation.determine(presentation_setup)

    layer_config = [input_layer] ++ hidden_layers ++ [output_layer]
    objective    = Objective.determine(objective_setup, output_layer)
    layers       = create_layers(layer_config)

    %{
      network: %{
        layers:       layers,
        objective:    objective,
        presentation: presentation
      },
      structure: structure
    }
  end

  defp create_layers(layers) do
    [first|_rest] = layers
    dropout       = Map.get(first, :dropout, :no_dropout)
    %{size: size} = first
    input_layer   = %{
      dropout: dropout,
      size:    size
    }

    create_layers(layers, 2, [input_layer])
  end

  defp create_layers([_|[]], _, accumulator) do
    Enum.reverse(accumulator)
  end

  defp create_layers([first, second|rest], count, accumulator) do
    %{size: rows} = first

    %{
      activity: function_setup,
      size:     columns,
    } = second

    name    = Map.get(second, :name,    "Layer #{count}")
    dropout = Map.get(second, :dropout, :no_dropout     )

    activity = Activation.determine(function_setup)

    initial_layer_config = %{
      activity: activity,
      biases:   :not_initialized,
      columns:  columns,
      name:     name,
      rows:     rows,
      weights:  :not_initialized,
    }

    new_layer_config = case rest do
      [] -> initial_layer_config
      _  -> initial_layer_config |> Map.put(:dropout, dropout)
    end

    create_layers([second|rest], count + 1, [new_layer_config|accumulator])
  end

  @doc """
  Initializez a neural network with the given setup.
  """
  @spec initialize(map, map) :: map
  def initialize(network_state, parameters) do
    %{network: network = %{layers: layers}} = network_state

    random_function    = Distribution.determine(parameters)
    [first|rest]       = layers
    initialized_layers = initialize_layers(rest, random_function, [])
    new_layers         = [first|initialized_layers]

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
