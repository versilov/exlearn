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

  #----------------------------------------------------------------------------
  # BatchData NIF API
  #----------------------------------------------------------------------------

  test "#generate_batch_data creates batch data" do
    worker_resource = Worker.create_worker_resource()

    first_data  = FileFixtures.first_data_bundle
    second_data = FileFixtures.second_data_bundle

    first_path  = TestUtil.temp_file_path_as_list("exlearn-neural_network-worker-nifs_test_3")
    second_path = TestUtil.temp_file_path_as_list("exlearn-neural_network-worker-nifs_test_4")

    :ok  = File.write(first_path,  first_data )
    :ok  = File.write(second_path, second_data)

    result = Worker.read_worker_data(worker_resource, [first_path, second_path])
    assert result == worker_resource

    result = Worker.generate_batch_data(worker_resource, 1)
    assert result == worker_resource

    :ok = File.rm(first_path )
    :ok = File.rm(second_path)
  end

  test "#shuffle_batch_data shuffles the batch data" do
    worker_resource = Worker.create_worker_resource()

    first_data  = FileFixtures.first_data_bundle
    second_data = FileFixtures.second_data_bundle

    first_path  = TestUtil.temp_file_path_as_list("exlearn-neural_network-worker-nifs_test_3")
    second_path = TestUtil.temp_file_path_as_list("exlearn-neural_network-worker-nifs_test_4")

    :ok  = File.write(first_path,  first_data )
    :ok  = File.write(second_path, second_data)

    result = Worker.read_worker_data(worker_resource, [first_path, second_path])
    assert result == worker_resource

    result = Worker.generate_batch_data(worker_resource, 1)
    assert result == worker_resource

    result = Worker.shuffle_batch_data(worker_resource)
    assert result == worker_resource

    :ok = File.rm(first_path )
    :ok = File.rm(second_path)
  end

  #----------------------------------------------------------------------------
  # NetworkState NIF API
  #----------------------------------------------------------------------------

  test "#create_network_state creates the newtwork state from definition" do
    worker_resource = Worker.create_worker_resource()

    # TODO: Note that the activation, objective and presentation contain the
    # function id and not the name. This must be replaced with a call to a
    # function that makes this change.
    network_parameters = %{
      layers: %{
        input:   %{size: 784, name: "Input",  dropout: 0.2               },
        hidden: [%{size: 100, name: "Hidden", dropout: 0.5, activation: 1}],
        output:  %{size: 10,  name: "Output",               activation: 2}
      },
      objective:    1,
      presentation: 2
    }

    result = Worker.create_network_state(worker_resource, network_parameters)
    assert result == worker_resource
  end

  test "#initialize_network_state sets biases and weights" do
    worker_resource = Worker.create_worker_resource()

    network_parameters = %{
      layers: %{
        input:   %{size: 784, name: "Input",  dropout: 0.2               },
        hidden: [%{size: 100, name: "Hidden", dropout: 0.5, activation: 1}],
        output:  %{size: 10,  name: "Output",               activation: 2}
      },
      objective:    1,
      presentation: 2
    }

    result = Worker.create_network_state(worker_resource, network_parameters)
    assert result == worker_resource

    initialization_parameters = %{
      distribution: :uniform,
      maximum:       1,
      minimum:      -1
    }

    result = Worker.initialize_network_state(worker_resource, initialization_parameters)
    assert result == worker_resource
  end

  #----------------------------------------------------------------------------
  # WorkerData NIF API
  #----------------------------------------------------------------------------

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

  #----------------------------------------------------------------------------
  # WorkerResource NIF API
  #----------------------------------------------------------------------------

  test "#create_worker_resource can be called" do
    worker_resource = Worker.create_worker_resource()

    assert worker_resource != nil
  end
end
