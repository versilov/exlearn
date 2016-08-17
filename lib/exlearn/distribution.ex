defmodule ExLearn.Distribution do
  @moduledoc """
  Translates distributon names to functions
  """

  @doc """
  Returns the appropriate function
  """
  @spec determine(map) :: function
  def determine(setup) do
    %{distribution: distribution} = setup
    case distribution do
      function when is_function(function, 2) -> function
      :normal  -> normal_distribution(setup)
      :uniform -> uniform_distribution(setup)
    end
  end

  defp normal_distribution(setup) do
    %{deviation: deviation, mean: mean} = setup

    case Map.get(setup, :modifier) do
      modifier when is_function(modifier, 3) ->
        fn(inputs, outputs) ->
          value = normal_with(mean, deviation)

          modifier.(value, inputs, outputs)
        end
      nil ->
        fn(_inputs, _outputs) -> normal_with(mean, deviation) end
    end
  end

  defp uniform_distribution(setup) do
    %{maximum: maximum, minimum: minimum} = setup

    case Map.get(setup, :modifier) do
      modifier when is_function(modifier, 3) ->
        fn(inputs, outputs) ->
          value = uniform_between(minimum, maximum)

          modifier.(value, inputs, outputs)
        end
      nil ->
        fn(_inputs, _outputs) -> uniform_between(minimum, maximum) end
    end
  end

  defp normal_with(mean, deviation) do
    value = :rand.normal

    value * deviation + mean
  end

  @spec uniform_between(number, number) :: float
  defp uniform_between(min, max) do
    value = :rand.uniform
    value * (max - min) + min
  end
end
