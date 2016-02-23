defmodule BrainTonic.Activation do
  @moduledoc """
  Translates distributon names to functions
  """

  @doc """
  Returns the appropriate function
  """
  @spec determine(map) :: (() -> float)
  def determine(setup) do
    case setup do
      %{function: function, derivative: derivative}
          when function |> is_function and derivative |> is_function ->
        %{function: function, derivative: derivative, values: []}
      %{activation: :identity} ->
        function   = fn (x) -> x end
        derivative = fn (x) -> 1 end
        %{function: function, derivative: derivative, values: []}
    end
  end
end