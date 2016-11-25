defmodule ExLearn.Util do
  @spec times(number, number, any, function):: any
  def times(count, data, accumulator, function)
  when is_function(function, 2)
  do
    times(0, count, data, accumulator, function)
  end

  defp times(current, count, _data, accumulator, _function)
  when current == count
  do
    accumulator
  end
  defp times(current, count, data, accumulator, function) do
    {rest, result} = function.(data, accumulator)

    times(current + 1, count, rest, result, function)
  end

  @spec zip_map(list, list, function) :: list
  def zip_map(first, second, function)
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
