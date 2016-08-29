defmodule ExLearn.NeuralNetwork.Propagator do
  @moduledoc """
  Backpropagates the error trough a network
  """

  alias ExLearn.{Activation, Matrix, Util}

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(map, map) :: map
  def back_propagate(forward_state, state) do
    %{network: %{layers: layers}} = state

    [_first|rest] = layers
    deltas        = calculate_deltas(forward_state, rest, state)

    %{activity: activity} = forward_state

    bias_change    = deltas
    weight_change  = calculate_weight_change(activity, deltas, [])

    {bias_change, weight_change}
  end

  defp calculate_deltas(forward_state, network_layers, state) do
    %{
      activity: [_first|rest],
      expected: expected,
      output:   output
    } = forward_state

    reversed_activity_layers = Enum.reverse(rest)
    reversed_network_layers  = Enum.reverse(network_layers)

    [last_activity_layer|other] = reversed_activity_layers

    %{network: %{objective: %{error: error_function}}} = state
    starting_delta = error_function.(expected, output, last_activity_layer)

    calculate_remaning_deltas(other, reversed_network_layers, [starting_delta])
  end

  defp calculate_remaning_deltas([], _, deltas) do
    deltas
  end

  defp calculate_remaning_deltas(activity_layers, network_layers, deltas) do
    [activity_layer|other_activity_layers] = activity_layers
    [network_layer|other_network_layers]   = network_layers

    %{
      derivative: derivative,
      input:      input
    } = activity_layer

    %{weights: weights} = network_layer

    [delta|_] = deltas

    output_gradient = Matrix.dot_nt(delta, weights)
    input_gradient  = Activation.apply(input, derivative)

    next_delta = case Map.get(activity_layer, :mask) do
      nil  -> Matrix.multiply(output_gradient, input_gradient)
      mask ->
        Matrix.multiply(output_gradient, input_gradient)
        |> Matrix.multiply(mask)
    end

    calculate_remaning_deltas(
      other_activity_layers,
      other_network_layers,
      [next_delta|deltas]
    )
  end

  defp calculate_weight_change(_, [], totals) do
    Enum.reverse(totals)
  end

  defp calculate_weight_change([a|as], [d|ds], total) do
    %{output: output} = a

    result = Matrix.dot_tn(output, d)

    calculate_weight_change(as, ds, [result|total])
  end

  def apply_changes(last_correction, correction, configuration, state) do
    %{network: network = %{layers: layers}} = state
    [first|rest] = layers

    new_layers = apply_changes(
      last_correction, correction, configuration, rest, state, []
    )
    new_network = Map.put(network, :layers, [first|new_layers])

    Map.put(state, :network, new_network)
  end

  def apply_changes(_, {[], []}, _, [], _state, new_layers) do
    Enum.reverse(new_layers)
  end

  def apply_changes(last_correction, correction, configuration, layers, state, new_layers) do
    {
      [bias_change  |other_bias_changes  ],
      [weight_change|other_weight_changes]
    } = correction

    %{
      batch_size:     batch_size,
      data_size:      data_size,
      learning_rate:  learning_rate,
      regularization: regularization
    } = configuration

    scale = learning_rate / batch_size

    [%{activity: activity, biases: biases, weights: weights}|other_layers] = layers

    new_biases = Matrix.multiply_with_scalar(bias_change, scale)
    |> Matrix.substract_inverse(biases)

    scaled_weights = Matrix.apply(
      weights,
      &regularization.(&1, learning_rate, data_size)
    )
    new_weights = Matrix.multiply_with_scalar(weight_change, scale)
    |> Matrix.substract_inverse(scaled_weights)

    {remaining_correction, final_weights} = apply_momentum(
      last_correction, new_weights, configuration
    )

    new_layer = %{activity: activity, biases: new_biases, weights: final_weights}

    apply_changes(
      remaining_correction,
      {other_bias_changes,
      other_weight_changes},
      configuration,
      other_layers,
      state,
      [new_layer|new_layers]
    )
  end

  defp apply_momentum([], weights, _), do: {[], weights}
  defp apply_momentum(last_correction, weights, configuration) do
    {
      [_bias_change |other_bias_changes  ],
      [weight_change|other_weight_changes]
    } = last_correction

    final_weights = case Map.get(configuration, :momentum) do
      nil      -> weights
      momentum
      when is_number(momentum) and momentum > 0.0 and momentum < 1.0
      ->
        weight_change
        |> Matrix.multiply_with_scalar(momentum)
        |> Matrix.add(weights)
    end

    {{other_bias_changes, other_weight_changes}, final_weights}
  end

  def reduce_correction(correction, total) do
    {bias_correction, weight_correction} = correction
    {bias_total,      weight_total     } = total

    final_bias   = Util.zip_map(bias_correction,   bias_total,   &Matrix.add/2)
    final_weight = Util.zip_map(weight_correction, weight_total, &Matrix.add/2)

    {final_bias, final_weight}
  end
end
