defmodule ExLearn.NeuralNetwork.Propagator do
  @moduledoc """
  Backpropagates the error trough a network
  """

  alias ExLearn.{Activation, Matrix, Util}

  @doc """
  Performs backpropagation
  """
  @spec back_propagate(map, map) :: map
  def back_propagate(forward_batch, state) do
    %{network: %{layers: network_layers}} = state

    deltas = calculate_deltas(forward_batch, network_layers, state)

    %{activity: activity, input: input} = forward_batch

    full_activity  = [%{output: input}|activity]
    bias_change    = deltas
    weight_change  = calculate_weight_change(full_activity, deltas, [])

    {bias_change, weight_change}
  end

  defp calculate_deltas(forward_state, network_layers, state) do
    %{
      activity: activity_layers,
      expected: expected,
      output:   output
    } = forward_state

    reversed_activity_layers = Enum.reverse(activity_layers)
    reversed_network_layers  = Enum.reverse(network_layers)

    [last_activity_layer|rest] = reversed_activity_layers

    %{network: %{objective: %{error: error_function}}} = state
    starting_delta = error_function.(expected, output, last_activity_layer)

    calculate_remaning_deltas(rest, reversed_network_layers, [starting_delta])
  end

  defp calculate_remaning_deltas([], _, deltas) do
    deltas
  end

  defp calculate_remaning_deltas(activity_layers, network_layers, deltas) do
    [activity_layer|other_activity_layers] = activity_layers
    [network_layer|other_network_layers]   = network_layers

    %{input: input}     = activity_layer
    %{weights: weights} = network_layer

    [delta|_] = deltas

    output_gradient = Matrix.dot_nt(delta, weights)
    input_gradient  = Activation.apply_derivative(input, activity_layer)

    next_delta = Matrix.multiply(output_gradient, input_gradient)

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
    result            = Matrix.dot_tn(output, d)

    calculate_weight_change(as, ds, [result|total])
  end

  def apply_changes({bias_change, weight_change}, configuration, state) do
    %{network: %{layers: layers}}     = state

    apply_changes({bias_change, weight_change}, configuration, layers, state, [])
  end

  def apply_changes({[], []}, _, [], state, new_layers) do
    %{network: network} = state

    new_network = put_in(network, [:layers], Enum.reverse(new_layers))

    put_in(state, [:network], new_network)
  end

  def apply_changes({bias_changes, weight_changes}, configuration, layers, state, new_layers) do
    %{
      batch_size:     batch_size,
      data_size:      data_size,
      learning_rate:  learning_rate,
      regularization: regularization
    } = configuration

    scale = learning_rate / batch_size

    [bias_change|other_bias_changes]     = bias_changes
    [weight_change|other_weight_changes] = weight_changes

    [%{activity: activity, biases: biases, weights: weights}|other_layers] = layers

    new_biases = Matrix.multiply_with_scalar(bias_change, scale)
    |> Matrix.substract_inverse(biases)

    scaled_weights = Matrix.apply(
      weights,
      &regularization.(&1, learning_rate, data_size)
    )
    new_weights = Matrix.multiply_with_scalar(weight_change, scale)
    |> Matrix.substract_inverse(scaled_weights)

    new_layer = %{activity: activity, biases: new_biases, weights: new_weights}

    apply_changes(
      {other_bias_changes,
      other_weight_changes},
      configuration,
      other_layers,
      state,
      [new_layer|new_layers]
    )
  end

  def reduce_correction(correction, total) do
    {bias_correction, weight_correction} = correction
    {bias_total,      weight_total     } = total

    final_bias   = Util.zip_map(bias_correction,   bias_total,   &Matrix.add/2)
    final_weight = Util.zip_map(weight_correction, weight_total, &Matrix.add/2)

    {final_bias, final_weight}
  end
end
