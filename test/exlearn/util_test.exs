defmodule ExLearn.UtilTest do
  use ExUnit.Case, async: true

  alias ExLearn.Util

  test "#times works like a reduce with limited steps" do
    data        = [1, 2, 3, 4]
    accumulator = 0
    count       = 3
    function    = fn(current, total) ->
      [first|rest] = current

      {rest, total + first}
    end

    assert Util.times(3, data, accumulator, function) == 6
   end

  test "#zip_map appplies a function on each pair of its arguments" do
    first    = [1, 2, 3]
    second   = [4, 5, 6]
    function = fn(x, y) -> x + y end
    expected = [5, 7, 9]

    assert Util.zip_map(first, second, function) == expected
  end

  test "#zip_map stops at the smallest size list" do
    first    = [1, 2, 3]
    second   = [4, 5]
    function = fn(x, y) -> x + y end
    expected = [5, 7]

    assert Util.zip_map(first, second, function) == expected
  end
end
