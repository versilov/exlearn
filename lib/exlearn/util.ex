defmodule ExLearn.Util do
  @spec zip_map(list, list, function) :: list
  def  zip_map(first, second, function)
  when is_list(first) and is_list(second) and is_function(function, 2) do
    zip_map(first, second, function, [])
  end

  defp zip_map([], _,  _, accumulator), do: Enum.reverse(accumulator)
  defp zip_map(_,  [], _, accumulator), do: Enum.reverse(accumulator)
  defp zip_map([x|first], [y|second], function, accumulator) do
    result = function.(x, y)

    zip_map(first, second, function, [result|accumulator])
  end
end
