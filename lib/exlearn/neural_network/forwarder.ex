defmodule ExLearn.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias ExLearn.{Activation, Matrix}

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity(list(number), map) :: [map]
  def forward_for_activity(sample, state) do
    %{network: %{layers: layers}} = state

    {input, expected} = sample

    calculate_activity(input, layers, [])
    |> Map.put(:expected, expected)
    |> Map.put(:input, input)
  end

  defp calculate_activity(output, [], activities) do
    %{activity: Enum.reverse(activities), output: output}
  end

  defp calculate_activity(layer_input, [layer|rest], activities) do
    %{
      activity: activity = %{function: function},
      biases:   biases,
      weights:  weights
    } = layer

    input  = Matrix.dot_and_add(layer_input, weights, biases)
    output = Activation.apply(input, function)

    new_activity = Map.put(activity, :input, input)
    |> Map.put(:output, output)

    calculate_activity(output, rest, [new_activity|activities])
  end

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec forward_for_output(list(number), map) :: [[number]]
  def forward_for_output(input, state) do
    %{
      network: %{
        layers:       layers,
        presentation: presentation
      }
    } = state

    {id, data} = input
    output     = calculate_output(data, layers)
    result     = presentation.(output)

    {id, result}
  end

  defp calculate_output(output, []    ), do: output
  defp calculate_output(input,  layers)  do
    [layer|other_layers] = layers

    %{
      activity: %{function: function},
      biases:   biases,
      weights:  weights
    } = layer

    Matrix.dot_and_add(input, weights, biases)
    |> Activation.apply(function)
    |> calculate_output(other_layers)
  end

  @spec forward_for_test(tuple, map) :: binary
  def forward_for_test(sample, state) do
    %{network: %{
      layers:       layers,
      objective:    %{function: function},
      presentation: presentation
    }} = state

    {input, expected} = sample
    output            = calculate_output(input, layers)
    error             = function.(expected, output)

    match = presentation.(expected) == presentation.(output)

    {error, match}
  end
end
