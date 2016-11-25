defmodule ExLearn.TestUtil do
  def temp_file_path do
    timestamp = :os.system_time(:micro_seconds) |> to_string

    "test/elixir/temp/exlearn-" <> timestamp
  end

  def temp_file_path(scope) do
    timestamp = :os.system_time(:micro_seconds) |> to_string

    "test/elixir/temp/exlearn-" <> scope <> "-" <> timestamp
  end

  def temp_file_path_as_list do
    :erlang.binary_to_list temp_file_path()
  end

  def temp_file_path_as_list(scope) do
    :erlang.binary_to_list temp_file_path(scope)
  end

  def write_to_file_as_binary(data, path) do
    binary = :erlang.term_to_binary(data)

    :ok = File.write(path, binary)
  end
end
