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

  @spec zip_with_fill(list, list, any) :: list
  def zip_with_fill(first, second, fill) do
    zip_with_fill(first, second, fill, [])
  end

  defp zip_with_fill([], [],  _, accumulator), do: Enum.reverse(accumulator)
  defp zip_with_fill([], [y|second], fill, accumulator) do
    zip_with_fill([], second, fill, [{fill, y}|accumulator])
  end
  defp zip_with_fill([x|first], [], fill, accumulator) do
    zip_with_fill(first, [], fill, [{x, fill}|accumulator])
  end
  defp zip_with_fill([x|first], [y|second], fill, accumulator) do
    zip_with_fill(first, second, fill, [{x, y}|accumulator])
  end
end
