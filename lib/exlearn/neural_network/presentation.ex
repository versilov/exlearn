defmodule ExLearn.NeuralNetwork.Presentation do
  alias ExLearn.Matrix

  @spec determine(map) :: function
  def determine(setup) do
    case setup do
      function when is_function(function) -> function
       :argmax                       -> &Matrix.argmax/1
      {:argmax, offset: offset}      -> argmax_function(offset)
       :raw                          -> &identity_function/1
       :round                        -> int_round_function()
      {:round, precision: precision} -> float_round_function(precision)
    end
  end

  defp argmax_function(offset) do
    fn(output) -> Matrix.argmax(output) + offset end
  end

  defp identity_function(output), do: output

  defp int_round_function do
    fn(output) -> Matrix.first(output) |> round end
  end

  defp float_round_function(precision) do
    fn(output) -> Matrix.first(output) |> Float.round(precision) end
  end
end
