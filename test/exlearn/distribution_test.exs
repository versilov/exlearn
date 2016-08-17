defmodule ExLearn.DistributionTest do
  use ExUnit.Case, async: true

  alias ExLearn.Distribution

  test "#determine returns the given function" do
    function = fn(inputs, outputs) -> inputs + outputs end
    setup    = %{distribution: function}

    result_function = Distribution.determine(setup)

    assert result_function.(1, 2) == 3
  end

  test "#determine returns the normal function" do
    setup = %{
      distribution: :normal,
      deviation:    2,
      mean:         3
    }

    result_function = Distribution.determine(setup)
    result          = result_function.(:not_used, :not_used)

    assert result |> is_number
  end

  test "#determine returns the normal function with modifier" do
    setup = %{
      distribution: :normal,
      deviation:    2,
      mean:         3,
      modifier:     fn(x, a, b) -> x + a + b end
    }

    result_function = Distribution.determine(setup)
    result          = result_function.(1, 2)

    assert result |> is_number
  end

  test "#determine returns the uniform function" do
    minimum = -1
    maximum =  1

    setup = %{
      distribution: :uniform,
      maximum:      maximum,
      minimum:      minimum
    }

    result_function = Distribution.determine(setup)
    result          = result_function.(:not_used, :not_used)

    assert result >= minimum && result <= maximum
  end

  test "#determine returns the uniform function with modifier" do
    minimum = -1
    maximum =  1

    setup = %{
      distribution: :uniform,
      maximum:      maximum,
      minimum:      minimum,
      modifier:     fn(x, a, b) -> x + a + b end
    }

    result_function = Distribution.determine(setup)
    result          = result_function.(1, 2)

    assert result >= minimum + 3 && result <= maximum + 3
  end
end
