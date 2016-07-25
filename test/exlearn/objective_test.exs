defmodule ObjectiveTest do
  use ExUnit.Case, async: true

  alias ExLearn.Objective

  test "#determine returns the given function pair" do
    first  = 1
    second = 2

    expected_from_function = 4
    expected_from_error    = 5

    given_function = fn(x, y)     -> x + y + 1 end
    given_error    = fn(x, y, _z) -> x + y + 2 end

    setup           = %{function: given_function, error: given_error}
    output_activity = %{arity: 1, derivative: &(&1 - 1)}
    output_layer    = %{activity: :does_not_matter}

    %{function: function, error: error} = Objective.determine(setup, output_layer)

    assert function.(first, second)               == expected_from_function
    assert error.(first, second, output_activity) == expected_from_error
  end

  test "#determine returns the cross entropy function and optimised error" do
    first      = [0.2, 0.2, 0.6]
    second     = [0.4, 0.5, 0.6]
    input      = [2,   3,   4  ]
    derivative = fn(x) -> x - 1 end
    data_size  = 1

    expected_from_function = 1.9580774929568254
    expected_from_error    = [0.2, 0.3, 0.0]

    setup           = :cross_entropy
    output_activity = %{arity: 1, derivative: derivative, input: input}
    output_layer    = %{activity: :logistic}

    %{function: function, error: error} = Objective.determine(setup, output_layer)

    assert function.(first, second, data_size)    == expected_from_function
    assert error.(first, second, output_activity) == expected_from_error
  end

  test "#determine returns the cross entropy function and simple error" do
    first      = [0.2, 0.2, 0.6]
    second     = [0.4, 0.5, 0.3]
    input      = [[1,   2,   3 ]]
    derivative = fn(x) -> x - 1 end
    data_size  = 1

    expected_from_function = 2.1501194861186237
    expected_from_error    = [0.0, 1.2, -2.857142857142857]

    setup           = :cross_entropy
    output_activity = %{arity: 1, derivative: derivative, input: input}
    output_layer    = %{activity: :not_logistic}

    %{function: function, error: error} = Objective.determine(setup, output_layer)

    assert function.(first, second, data_size)    == expected_from_function
    assert error.(first, second, output_activity) == expected_from_error
  end

  test "#determine returns the negative log likelihood function and optimised error" do
    first      = [1,   0,   0  ]
    second     = [0.6, 0.3, 0.1]
    input      = [[2,   3,   4  ]]
    derivative = fn(x) -> x - 1 end
    data_size  = 1

    expected_from_function = 0.5108256237659907
    expected_from_error    = [-0.4, 0.3, 0.1]

    setup           = :negative_log_likelihood
    output_activity = %{arity: 2, derivative: derivative, input: input}
    output_layer    = %{activity: :softmax}

    %{function: function, error: error} = Objective.determine(setup, output_layer)

    assert function.(first, second, data_size)    == expected_from_function
    assert error.(first, second, output_activity) == expected_from_error
  end

  test "#determine returns the negative log likelihood function and simple error" do
    first      = [1,   0,   0  ]
    second     = [0.6, 0.3, 0.1]
    input      = [[2,   3,   4  ]]
    derivative = fn(x) -> x - 1 end
    data_size  = 1

    expected_from_function = 0.5108256237659907
    expected_from_error    = [-0.4, 0.3, 0.1]

    setup           = :negative_log_likelihood
    output_activity = %{arity: 1, derivative: derivative, input: input}
    output_layer    = %{activity: :not_softmax}

    %{function: function, error: error} = Objective.determine(setup, output_layer)

    assert function.(first, second, data_size)    == expected_from_function
    assert error.(first, second, output_activity) == expected_from_error
  end

  test "#determine returns the quadratic function pair" do
    first      = [1, 2, 3]
    second     = [1, 2, 7]
    input      = [[2, 3, 4]]
    derivative = fn(x) -> x - 1 end
    data_size  = 1

    expected_from_function = 8
    expected_from_error    = [0, 0, 12]

    setup           = :quadratic
    output_activity = %{arity: 1, derivative: derivative, input: input}
    output_layer    = %{activity: :does_not_matter}

    %{function: function, error: error} = Objective.determine(setup, output_layer)

    assert function.(first, second, data_size)    == expected_from_function
    assert error.(first, second, output_activity) == expected_from_error
  end
end
