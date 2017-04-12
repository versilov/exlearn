defmodule ExLearn.Activation do
  @moduledoc """
  Translates distributon names to functions
  """

  alias ExLearn.Matrix

  @doc """
  Applies the given function based on arity
  """
  @spec apply(binary, function) :: binary
  def apply(data, function)
  when is_function(function, 1)
  do
    function.(data)
  end

  def apply(data, function)
  when is_function(function, 2)
  do
    Matrix.apply(data, &function.(&1, data))
  end

  @doc """
  Returns the appropriate function
  """
  @spec determine(atom | map) :: map
  def determine(setup) do
    case setup do
      %{function: function, derivative: derivative}
      when is_function(function, 2) and is_function(derivative, 2) ->
        %{function: function, derivative: derivative}
      :arctan        -> arctan_pair()             # 0
      :bent_identity -> bent_identity_pair()      # 1
      :gaussian      -> gaussian_pair()           # 2
      :identity      -> identity_pair()           # 3
      :logistic      -> logistic_pair()           # 4
      :relu          -> relu_pair()               # 5
      :sinc          -> sinc_pair()               # 6
      :sinusoid      -> sinusoid_pair()           # 7
      :softmax       -> softmax_pair()            # 8
      :softplus      -> softplus_pair()           # 9
      :softsign      -> softsign_pair()           # 10
      :tanh          -> tanh_pair()               # 11
      {:elu,   alpha: alpha} -> elu_pair(alpha)   # 12
      {:prelu, alpha: alpha} -> prelu_pair(alpha) # 13
    end
  end

  @spec arctan_pair :: map
  defp arctan_pair do
    function   = fn(x, _all) -> :math.atan(x)   end
    derivative = fn(x, _all) -> 1 / (x * x + 1) end

    %{function: function, derivative: derivative}
  end

  @spec bent_identity_pair :: map
  defp bent_identity_pair do
    function   = fn(x, _all) -> (:math.sqrt(x * x + 1) - 1) / 2 + x end
    derivative = fn(x, _all) -> x / (2 * :math.sqrt(x * x + 1)) + 1 end

    %{function: function, derivative: derivative}
  end

  @spec elu_pair(number) :: map
  defp elu_pair(alpha) do
    function = fn
      (x, _all) when x < 0 -> alpha * (:math.exp(x) - 1)
      (x, _all)            -> x
    end

    derivative = fn
      (x,  _all) when x < 0 -> function.(x, :not_needed) + alpha
      (_x, _all)            -> 1
    end

    %{function: function, derivative: derivative}
  end

  @spec gaussian_pair :: map
  defp gaussian_pair do
    function   = fn(x, _all) -> :math.exp(-x * x)          end
    derivative = fn(x, _all) -> -2 * x * :math.exp(-x * x) end

    %{function: function, derivative: derivative}
  end

  @spec identity_pair :: map
  defp identity_pair do
    function   = fn(x,  _all) -> x end
    derivative = fn(_x, _all) -> 1 end

    %{function: function, derivative: derivative}
  end

  @spec logistic_pair :: map
  defp logistic_pair do
    function   = fn
      (x, _all) when x >  709 -> 1
      (x, _all) when x < -709 -> 0
      (x, _all)               -> 1 / (1 + :math.exp(-x))
    end

    derivative = fn(x, _all) ->
      result = function.(x, :not_needed)

      result * (1 - result)
    end

    %{function: function, derivative: derivative}
  end

  @spec prelu_pair(number) :: map
  defp prelu_pair(alpha) do
    function = fn
      (x, _all) when x < 0 -> alpha * x
      (x, _all)            -> x
    end

    derivative = fn
      (x,  _all) when x < 0 -> alpha
      (_x, _all)            -> 1
    end

    %{function: function, derivative: derivative}
  end

  @spec relu_pair :: map
  defp relu_pair do
    function = fn
      (x, _all) when x < 0 -> 0
      (x, _all)            -> x
    end

    derivative = fn
      (x,  _all) when x < 0 -> 0
      (_x, _all)            -> 1
    end

    %{function: function, derivative: derivative}
  end

  @spec sinc_pair :: map
  defp sinc_pair do
    function   = fn
      (x, _all) when x == 0 -> 1
      (x, _all)             -> :math.sin(x) / x
    end

    derivative = fn
      (x, _all) when x == 0 -> 0
      (x, _all)             -> :math.cos(x) / x - :math.sin(x) / (x * x)
    end

    %{function: function, derivative: derivative}
  end

  @spec sinusoid_pair :: map
  defp sinusoid_pair do
    function   = fn(x, _all) -> :math.sin(x) end
    derivative = fn(x, _all) -> :math.cos(x) end

    %{function: function, derivative: derivative}
  end

  @spec softmax_pair :: map
  defp softmax_pair do
    function   = fn(x, all) ->
      maximum_element = Matrix.max(all)
      normalizer = Matrix.apply(
        all,
        fn(element) -> :math.exp(element - maximum_element) end
      ) |> Matrix.sum

      :math.exp(x - maximum_element) / normalizer
    end

    derivative = fn(matrix) ->
      Matrix.apply(matrix, fn(first_element, first_index) ->
        Matrix.apply(matrix, fn(second_element, second_index) ->
          case first_index == second_index do
            true  -> first_element * (1 - second_element)
            false -> -1 * first_element * second_element
          end
        end)
        |> Matrix.sum
      end)
    end

    %{function: function, derivative: derivative}
  end

  @spec softplus_pair :: map
  defp softplus_pair do
    function   = fn(x, _all) -> :math.log(1 + :math.exp(x)) end
    derivative = fn(x, _all) -> 1 / (1 + :math.exp(-x))     end

    %{function: function, derivative: derivative}
  end

  @spec softsign_pair :: map
  defp softsign_pair do
    function   = fn(x, _all) -> x / (1 + abs(x)) end
    derivative = fn(x, _all) ->
      base = 1 + abs(x)

      1 / (base * base)
    end

    %{function: function, derivative: derivative}
  end

  @spec tanh_pair :: map
  defp tanh_pair do
    function   = fn(x, _all) -> :math.tanh(x) end
    derivative = fn(x, _all) ->
      result = function.(x, :not_needed)

      1 - result * result
    end

    %{function: function, derivative: derivative}
  end
end
