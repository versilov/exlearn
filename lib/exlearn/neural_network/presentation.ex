defmodule ExLearn.NeuralNetwork.Presentation do
  alias ExLearn.Matrix

  def determine(setup) do
    case setup do
      function when is_function(function) -> function
       :argmax                  -> argmax_function(0     )
      {:argmax, offset: offset} -> argmax_function(offset)
       :identity                -> &identity_function/1
    end
  end

  defp argmax_function(offset) do
    fn(output) -> Matrix.argmax(output) + offset end
  end

  defp identity_function(output), do: output
end
