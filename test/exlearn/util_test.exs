defmodule ExLearn.UtilTest do
  use ExUnit.Case, async: true

  alias ExLearn.Util

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

  test "#zip_with_fill adds fill to the smallest list" do
    assert Util.zip_with_fill([],        [],     0)  == []
    assert Util.zip_with_fill([1],       [],     2)  == [{1, 2}]
    assert Util.zip_with_fill([],        [1],    2)  == [{2, 1}]
    assert Util.zip_with_fill([1, 2],    [3],    4)  == [{1, 3}, {2, 4}]
    assert Util.zip_with_fill([1],       [2, 3], 4)  == [{1, 2}, {4, 3}]
    assert Util.zip_with_fill([1, 2, 3], [4],    5)  == [{1, 4}, {2, 5}, {3, 5}]
  end
end
