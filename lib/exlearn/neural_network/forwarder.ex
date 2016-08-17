defmodule ExLearn.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias ExLearn.{Activation, Matrix}

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity([number], map) :: [map]
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
      activity: activity,
      biases:   biases,
      weights:  weights
    } = layer

    input  = Matrix.dot_and_add(layer_input, weights, biases)
    output = Activation.apply_function(input, activity)

    new_activity = Map.put(activity, :input, input)
    |> Map.put(:output, output)

    calculate_activity(output, rest, [new_activity|activities])
  end

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec forward_for_output([number], map) :: [[number]]
  def forward_for_output(input, state) do
    %{
      network: %{
        layers:       layers,
        presentation: presentation
      }
    } = state

    calculate_output(input, layers, presentation)
  end

  defp calculate_output(output, [], presentation) do
    presentation.(output)
  end

  defp calculate_output(input, layers, presentation) do
    [layer|other_layers] = layers

    %{
      activity: activity,
      biases:   biases,
      weights:  weights
    } = layer

    Matrix.dot_and_add(input, weights, biases)
    |> Activation.apply_function(activity)
    |> calculate_output(other_layers, presentation)
  end

  @spec forward_for_test([[number]], map) :: [[number]]
  def forward_for_test(sample, state) do
    %{network: %{layers: layers}} = state

    {input, expected} = sample

    calculate_test(%{input: input, expected: expected}, input, layers)
  end

  defp calculate_test(sample, output, []) do
    Map.put(sample, :output, output)
  end

  defp calculate_test(sample, input, [layer|rest]) do
    %{
      activity: activity,
      biases:   biases,
      weights:  weights
    } = layer

    output = Matrix.dot_and_add(input, weights, biases)
    |> Activation.apply_function(activity)

    calculate_test(sample, output, rest)
  end
end
