defmodule ExLearn.Util do
  def zip_map(first, second, function) do
    zip_map(first, second, function, [])
  end

  defp zip_map([], _,  _, accumulator), do: Enum.reverse(accumulator)
  defp zip_map(_,  [], _, accumulator), do: Enum.reverse(accumulator)
  defp zip_map([x|first], [y|second], function, accumulator) do
    result = function.(x, y)

    zip_map(first, second, function, [result|accumulator])
  end
end
