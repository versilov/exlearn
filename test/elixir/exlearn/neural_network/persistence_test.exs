Code.require_file("test/elixir/test_util.exs")

defmodule ExLearn.NeuralNetwork.PersistenceTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Persistence

  alias ExLearn.TestUtil

  setup do
    path = TestUtil.temp_file_path("exlearn-neural_network-persistence_test")

    first_network_state = %{
      network: %{
        layers: [
          %{
            biases:   Matrix.new(1, 3, [[1, 2, 3]]),
            weights:  Matrix.new(3, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
          },
          %{
            biases:   Matrix.new(1, 2, [[4, 5]]),
            weights:  Matrix.new(3, 2, [[1, 2], [3, 4], [5, 6]])
          },
          %{
            biases:   Matrix.new(1, 2, [[6, 7]]),
            weights:  Matrix.new(2, 2, [[1, 2], [3, 4]])
          }
        ]
      }
    }

    second_network_state = %{
      network: %{
        layers: [
          %{
            biases:   Matrix.new(1, 3, [[2, 3, 4]]),
            weights:  Matrix.new(3, 3, [[2, 3, 4], [5, 6, 7], [8, 9, 10]])
          },
          %{
            biases:   Matrix.new(1, 2, [[5, 6]]),
            weights:  Matrix.new(3, 2, [[2, 3], [4, 5], [6, 7]])
          },
          %{
            biases:   Matrix.new(1, 2, [[7, 8]]),
            weights:  Matrix.new(2, 2, [[2, 3], [4, 5]])
          }
        ]
      }
    }

    {:ok, setup: %{
      path:                 path,
      first_network_state:  first_network_state,
      second_network_state: second_network_state
    }}
  end

  test "#load restores the state from a file", %{setup: setup} do
    %{
      path:                 path,
      first_network_state:  first_network_state,
      second_network_state: second_network_state,
    } = setup

    :ok            = Persistence.save(first_network_state,  path)
    restored_state = Persistence.load(second_network_state, path)

    assert restored_state == first_network_state
    refute restored_state == second_network_state

    :ok = File.rm(path)
  end

  test "#save stores the state to a file", %{setup: setup} do
    %{
      path:                path,
      first_network_state: network_state,
    } = setup

    :ok            = Persistence.save(network_state, path)
    restored_state = Persistence.load(network_state, path)

    assert restored_state == network_state

    :ok = File.rm(path)
  end
end
