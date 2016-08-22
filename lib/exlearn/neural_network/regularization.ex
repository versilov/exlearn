defmodule ExLearn.NeuralNetwork.Regularization do
  @moduledoc """
  Translates regularization names to functions
  """

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map) :: map
  def determine(setup) do
    case setup do
       :none            -> &identity/3
      {:L1, rate: rate} -> l1_function(rate)
      {:L2, rate: rate} -> l2_function(rate)
    end
  end

  defp identity(weight, _, _), do: weight

  defp l1_function(regularization_rate) do
    fn(weight, learning_rate, data_size) ->
      chunk = learning_rate * regularization_rate * normalized_sign(weight)

      weight - chunk / data_size
    end
  end

  defp l2_function(regularization_rate) do
    fn(weight, learning_rate, data_size) ->
      weight * (1 - learning_rate * regularization_rate / data_size)
    end
  end

  defp normalized_sign(number) when is_number(number) do
    case number do
      0            ->  0
      n when n < 0 -> -1
      _            ->  1
    end
  end
end
