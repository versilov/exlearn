[
  "test/elixir/test_util.exs",
  "test/elixir/fixtures/file_fixtures.exs"
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Worker.NifsTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil
  alias ExLearn.FileFixtures

  test "#create_worker_resource can be called" do
    worker_resource = Worker.create_worker_resource()

    assert worker_resource != nil
  end

  test "#read_worker_data diaplys the internal structure" do
    worker_resource = Worker.create_worker_resource()

    first_data  = FileFixtures.first_data_bundle
    second_data = FileFixtures.second_data_bundle

    first_path  = TestUtil.temp_file_path_as_list("exlearn-neural_network-worker-nifs_test_3")
    second_path = TestUtil.temp_file_path_as_list("exlearn-neural_network-worker-nifs_test_4")

    :ok  = File.write(first_path,  first_data )
    :ok  = File.write(second_path, second_data)

    result = Worker.read_worker_data(worker_resource, [first_path, second_path])

    assert result == worker_resource

    :ok = File.rm(first_path )
    :ok = File.rm(second_path)
  end
end
