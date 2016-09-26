defmodule ExLearn.Objective do
  @moduledoc """
  Translates objective names to functions
  """

  alias ExLearn.Activation
  alias ExLearn.Matrix

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map, map) :: map
  def determine(setup, output_layer) do
    case setup do
      %{function: function, error: error}
      when is_function(function) and is_function(error) ->
        %{function: function, error: error}
      :cross_entropy           -> cross_entropy_pair(output_layer)
      :negative_log_likelihood -> negative_log_likelihood_pair(output_layer)
      :quadratic               -> quadratic_pair
    end
  end

  @spec cross_entropy_pair(map) :: map
  defp cross_entropy_pair(output_layer) do
    function = &cross_entropy_function/2
    error    = cross_entropy_error(output_layer)

    %{function: function, error: error}
  end

  @spec cross_entropy_function(binary, binary) :: float
  defp cross_entropy_function(expected, actual) do
    binary_entropy_sum = Matrix.apply(expected, actual, fn(x, y) ->
      normalized = case y do
        0.0 -> 0.0000000001
        1.0 -> 0.9999999999
        _   -> y
      end

      x * :math.log(normalized) + (1 - x) * :math.log(1 - normalized)
    end) |> Matrix.sum

    -1 * binary_entropy_sum
  end

  @spec cross_entropy_error(map) :: function
  defp cross_entropy_error(%{activity: activity}) do
    case activity do
      :logistic -> &cross_entropy_error_optimised/3
      _         -> &cross_entropy_error_simple/3
    end
  end

  @spec cross_entropy_error_simple(binary, binary, map) :: binary
  defp cross_entropy_error_simple(expected, actual, layer) do
    %{
      derivative: derivative,
      input:      input
    } = layer

    input_derivative = Activation.apply(input, derivative)
    top              = Matrix.substract(actual, expected)
    bottom           = Matrix.apply(actual, fn(element) ->
      element * (1 - element)
    end)

    Matrix.divide(top, bottom)
    |> Matrix.multiply(input_derivative)
  end

  @spec cross_entropy_error_optimised(binary, binary, map) :: binary
  defp cross_entropy_error_optimised(expected, actual, _layer) do
    Matrix.substract(actual, expected)
  end

  @spec negative_log_likelihood_pair(map) :: map
  defp negative_log_likelihood_pair(output_layer) do
    function = &negative_log_likelihood_function/2
    error    = negative_log_likelihood_error(output_layer)

    %{function: function, error: error}
  end

  @spec negative_log_likelihood_function(binary, binary) :: float
  defp negative_log_likelihood_function(expected, actual) do
    -1 * Matrix.sum(
      Matrix.multiply(
        expected,
        Matrix.apply(actual, &:math.log/1)
      )
    )
  end

  @spec negative_log_likelihood_error(map) :: binary
  defp negative_log_likelihood_error(%{activity: activity}) do
    case activity do
      :softmax -> &negative_log_likelihood_error_optimised/3
      _        -> &negative_log_likelihood_error_simple/3
    end
  end

  # TODO: This seems to work but no idea why
  @spec negative_log_likelihood_error_simple(binary, binary, %{}) :: []
  defp negative_log_likelihood_error_simple(expected, actual, _layer) do
    Matrix.substract(actual, expected)
  end

  @spec negative_log_likelihood_error_optimised(binary, binary, %{}) :: []
  defp negative_log_likelihood_error_optimised(expected, actual, _layer) do
    Matrix.substract(actual, expected)
  end

  @spec quadratic_pair :: map
  defp quadratic_pair do
    function = &quadratic_cost_function/2
    error    = &quadratic_cost_error/3

    %{function: function, error: error}
  end

  @spec quadratic_cost_function(binary, binary) :: float
  defp quadratic_cost_function(expected, actual) do
    0.5 * Matrix.sum(
      Matrix.apply(expected, actual, fn(x, y) ->
        product = x - y

        product * product
      end)
    )
  end

  @spec quadratic_cost_error(binary, binary, map) :: binary
  defp quadratic_cost_error(expected, actual, layer) do
    %{
      derivative: derivative,
      input:      input
    } = layer

    cost_gradient    = Matrix.substract(actual, expected)
    input_derivative = Activation.apply(input, derivative)

    Matrix.multiply(cost_gradient, input_derivative)
  end
end
