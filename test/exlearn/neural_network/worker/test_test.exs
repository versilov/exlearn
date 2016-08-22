Code.require_file("test/fixtures/neural_network/worker_fixtures.exs")

defmodule ExLearn.NeuralNetwork.Worker.TestTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Worker

  alias ExLearn.NeuralNetwork.WorkerFixtures

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:    name,
      options: options
    }}
  end

  test "#test returns the test results", %{setup: setup} do
    %{name: worker, options: options} = setup

    first_sample = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_sample = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    first_expected = %{
        input:    Matrix.new(1, 3, [[1, 2, 3]]),
        expected: Matrix.new(1, 2, [[1900, 2800]]),
        output:   Matrix.new(1, 2, [[1897, 2784]])
      }
    second_expected = %{
        input:    Matrix.new(1, 3, [[2, 3, 4]]),
        expected: Matrix.new(1, 2, [[2600, 3800]]),
        output:   Matrix.new(1, 2, [[2620, 3846]])
      }

    data          = [first_sample,    second_sample ]
    expected      = [second_expected, first_expected]
    network_state = WorkerFixtures.initial_network_state

    args = %{data: %{location: :memory, source: data}}

    {:ok, _worker_pid} = Worker.start_link(args, options)

    Worker.test(network_state, worker)
    result = Worker.get(worker)

    assert result == expected
  end
end
