[
  "test/test_util.exs",
  "test/fixtures/data_fixtures.exs",
  "test/fixtures/neural_network/worker_fixtures.exs"
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Worker.PredictTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.TestUtil
  alias ExLearn.DataFixtures
  alias ExLearn.NeuralNetwork.WorkerFixtures

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:    name,
      options: options
    }}
  end

  test "#predict with data in file returns the prediction", %{setup: setup} do
    %{name: worker, options: options} = setup

    data          = DataFixtures.first_predict
    expected      = [{<<1 :: float-little-32>>, Matrix.new(1, 2, [[1897, 2784]])}]
    network_state = WorkerFixtures.initial_network_state

    path = TestUtil.temp_file_path("exlearn-neural_network-worker-predict_test")
    :ok  = File.write(path, data)

    args = %{data: %{location: :file, source: [path]}}

    {:ok, _pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data
    Worker.predict(network_state, worker)
    result = Worker.get(worker)

    assert result == expected

    :ok = File.rm(path)
  end

  test "#predict with data in memory returns the prediction", %{setup: setup} do
    %{
      name:    worker,
      options: options
    } = setup

    data          = [{1, Matrix.new(1, 3, [[1, 2, 3]]   )}]
    expected      = [{1, Matrix.new(1, 2, [[1897, 2784]])}]
    network_state = WorkerFixtures.initial_network_state

    args = %{data: %{location: :memory, source: data}}

    {:ok, _pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data
    Worker.predict(network_state, worker)
    result = Worker.get(worker)

    assert result == expected
  end
end
