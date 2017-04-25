defmodule ExLearn.Matrix do
  @moduledoc """
  Creates matrices in both binary and tuple representation.
  """

  @doc """
  Creates a new matrix.
  """

  @spec new(list(list)) :: binary
  def new(list_of_lists) when is_list(list_of_lists) do
  end

  @spec new(non_neg_integer, non_neg_integer, list(list)) :: binary
  def new(rows, columns, list_of_lists) when is_list(list_of_lists) do
    initial = <<rows :: float-little-32, columns :: float-little-32>>

    Enum.reduce(list_of_lists, initial, fn(list, accumulator) ->
      accumulator <> Enum.reduce(list, <<>>, fn(element, partial) ->
        partial <> <<element :: float-little-32>>
      end)
    end)
  end
end
