defmodule ExLearn.Objective do
  @moduledoc """
  Translates objective names to functions
  """

  alias ExLearn.{Activation, Matrix, Vector}

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map, map) :: map
  def determine(setup, output_layer) do
    case setup do
      %{function: function, error: error}
          when function |> is_function and error |> is_function ->
        %{function: function, error: error}
      :cross_entropy           -> cross_entropy_pair(output_layer)
      :negative_log_likelihood -> negative_log_likelihood_pair(output_layer)
      :quadratic               -> quadratic_pair
    end
  end

  @spec cross_entropy_pair(map) :: map
  defp cross_entropy_pair(output_layer) do
    function = &cross_entropy_function/3
    error    = cross_entropy_error(output_layer)

    %{function: function, error: error}
  end

  @spec cross_entropy_function([number], [number], non_neg_integer) :: float
  defp cross_entropy_function(expected, actual, data_size) do
    binary_entropy_sum = Matrix.apply(expected, actual, fn(x, y) ->
      x * :math.log(y) + (1 - x) * :math.log(1 - y)
    end) |> Matrix.sum

    -1 / data_size * binary_entropy_sum
  end

  @spec cross_entropy_error(map) :: function
  defp cross_entropy_error(%{activity: activity}) do
    case activity do
      :logistic -> &cross_entropy_error_optimised/3
      _         -> &cross_entropy_error_simple/3
    end
  end

  @spec cross_entropy_error_simple([number], [number], %{}) :: [number]
  defp cross_entropy_error_simple(expected, actual, layer) do
    %{input: input} = layer

    input_derivative = Activation.apply_derivative(input, layer)
    top              = Matrix.substract(actual, expected)
    bottom           = Matrix.apply(actual, fn(element) ->
      element * (1 - element)
    end)

    Matrix.divide(top, bottom)
    |> Matrix.multiply(input_derivative)
  end

  @spec cross_entropy_error_optimised([number], [number], %{}) :: [number]
  defp cross_entropy_error_optimised(expected, actual, _layer) do
    Matrix.substract(actual, expected)
  end

  @spec negative_log_likelihood_pair(map) :: map
  defp negative_log_likelihood_pair(output_layer) do
    function = &negative_log_likelihood_function/3
    error    = negative_log_likelihood_error(output_layer)

    %{function: function, error: error}
  end

  @spec negative_log_likelihood_function([number], [number], non_neg_integer) :: float
  defp negative_log_likelihood_function(expected, actual, data_size) do
    -1 / data_size * Matrix.sum(
      Matrix.multiply(
        expected,
        Matrix.apply(actual, &:math.log/1)
      )
    )
  end

  @spec negative_log_likelihood_error(map) :: []
  defp negative_log_likelihood_error(%{activity: activity}) do
    case activity do
      :softmax -> &negative_log_likelihood_error_optimised/3
      _        -> &negative_log_likelihood_error_simple/3
    end
  end

  # TODO: This seems to work but no idea why
  @spec negative_log_likelihood_error_simple([number], [number], %{}) :: []
  defp negative_log_likelihood_error_simple(expected, actual, _layer) do
    Matrix.substract(actual, expected)
  end

  @spec negative_log_likelihood_error_optimised([number], [number], %{}) :: []
  defp negative_log_likelihood_error_optimised(expected, actual, _layer) do
    Matrix.substract(actual, expected)
  end

  @spec quadratic_pair :: map
  defp quadratic_pair do
    function = &quadratic_cost_function/3
    error    = &quadratic_cost_error/3

    %{function: function, error: error}
  end

  @spec quadratic_cost_function([number], [number], non_neg_integer) :: float
  defp quadratic_cost_function(expected, actual, data_size) do
    1 / (2 * data_size) * Matrix.sum(
      Matrix.apply(expected, actual, fn(x, y) ->
        product = x - y

        product * product
      end)
    )
  end

  @spec quadratic_cost_error([], [], %{}) :: []
  defp quadratic_cost_error(expected, actual, layer) do
    %{input: input} = layer

    cost_gradient    = Matrix.substract(actual, expected)
    input_derivative = Activation.apply_derivative(input, layer)

    Matrix.multiply(cost_gradient, input_derivative)
  end
end
