defmodule ExLearn.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias ExLearn.Activation
  alias ExLearn.Matrix

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity(list(number), map) :: [map]
  def forward_for_activity(sample, state) do
    %{network: %{layers: layers}} = state

    [first|rest]      = layers
    {input, expected} = sample

    activity = case Map.get(first, :dropout, :no_dropout) do
      :no_dropout ->
        calculate_activity(input, rest, [%{output: input}])
      dropout
      when is_number(dropout) and dropout > 0.0 and dropout < 1.0
      ->
        %{size: size}  = first
        mask = Matrix.new(
          1,
          size,
          fn ->
            case :rand.uniform do
              x when x < dropout -> 0
              _                  -> 1 / (1 - dropout)
            end
          end
        )

        initial_input = Matrix.multiply(input, mask)

        calculate_activity(
          initial_input,
          rest,
          [%{mask: mask, output: initial_input}]
        )
    end

    activity
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

    case Map.get(layer, :dropout, :no_dropout) do
      :no_dropout ->
        output = Activation.apply(input, function)

        new_activity = Map.put(activity, :input, input)
        |> Map.put(:output, output)

        calculate_activity(output, rest, [new_activity|activities])
      dropout
      when is_number(dropout) and dropout > 0.0 and dropout < 1.0
      ->
        %{columns: columns} = layer
        mask = Matrix.new(
          1,
          columns,
          fn ->
            case :rand.uniform do
              x when x < dropout -> 0
              _                  -> 1 / (1 - dropout)
            end
          end
        )

        output = Activation.apply(input, function)
        |> Matrix.multiply(mask)

        new_activity =  Map.put(activity, :input,  input )
        |> Map.put(:mask,   mask  )
        |> Map.put(:output, output)

        calculate_activity(output, rest, [new_activity|activities])
    end
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

    [_first|rest] = layers
    {id, data}    = input
    output        = calculate_output(data, rest)
    result        = presentation.(output)

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

    [_first|rest]     = layers
    {input, expected} = sample
    output            = calculate_output(input, rest)
    error             = function.(expected, output)

    match = presentation.(expected) == presentation.(output)

    {error, match}
  end
end
