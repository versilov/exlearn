defmodule ExLearn.NeuralNetwork.Correction do
  @moduledoc """
  Extracts corrections as Erlang objects from C nifs.
  """

  @on_load :load_nifs

  @spec load_nifs :: :ok
  def load_nifs do
    :ok = :erlang.load_nif('./priv/correction_nifs', 0)
  end

  @spec from_c :: binary
  def from_c do
    :erlang.nif_error(:nif_library_not_loaded) # excoveralls ignore

    random_size = :rand.uniform(2)             # excoveralls ignore
    <<1 :: size(random_size)>>                 # excoveralls ignore
  end
end
