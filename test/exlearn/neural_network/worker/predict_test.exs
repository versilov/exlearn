defmodule ExLearn.NeuralNetwork.Worker.PredictTest do
  use ExUnit.Case, async: true

  alias ExLearn.{Matrix, TestUtils}
  alias ExLearn.NeuralNetwork.{Worker, WorkerFixtures}

  test "#work|:ask with data in file returns the ask data", %{setup: setup} do
    %{
      name:          worker,
      network_state: network_state,
      options:       options,
      path:          path
    } = setup

    data   = [Matrix.new(1, 3, [[1, 2, 3]])]
    binary = :erlang.term_to_binary(data)
    :ok    = File.write(path, binary)

    args = %{
      batch_size:     1,
      data:           [path],
      data_location:  :file,
      learning_rate:  2,
      regularization: :none
    }

    {:ok, _pid} = Worker.start_link(args, options)

    expected = [Matrix.new(1, 2, [[1897, 2784]])]
    result   = Worker.work(:ask, network_state, worker)

    assert result == expected

    :ok = File.rm(path)
  end

  test "#work|:ask with data in memory returns the ask data", %{setup: setup} do
    %{
      name:          worker,
      network_state: network_state,
      options:       options
    } = setup

    args = %{
      batch_size:     1,
      data:           [Matrix.new(1, 3, [[1, 2, 3]])],
      data_location:  :memory,
      learning_rate:  :not_needed,
      regularization: :none
    }

    {:ok, _pid} = Worker.start_link(args, options)

    expected = [Matrix.new(1, 2, [[1897, 2784]])]
    result   = Worker.work(:ask, network_state, worker)

    assert result == expected
  end
end
