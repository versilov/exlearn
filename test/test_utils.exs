defmodule ExLearn.TestUtils do
  def temp_file_path do
    timestamp = :os.system_time(:micro_seconds) |> to_string

    "test/temp/exlearn-" <> timestamp
  end

  def temp_file_path(scope) do
    timestamp = :os.system_time(:micro_seconds) |> to_string

    "test/temp/exlearn-" <> scope <> "-" <> timestamp
  end

  def write_to_file_as_binary(data, path) do
    binary = :erlang.term_to_binary(data)

    :ok = File.write(path, binary)
  end
end
