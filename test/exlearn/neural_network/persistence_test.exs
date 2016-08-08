defmodule ExLearn.NeuralNetwork.PersistenceTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Persistence

  setup do
    timestamp = :os.system_time(:milli_seconds) |> to_string
    path      = "test/temp/" <> timestamp

    first_network_state = %{
      network: %{
        layers: [
          %{
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          }
        ]
      }
    }

    second_network_state = %{
      network: %{
        layers: [
          %{
            biases:   [[2, 3, 4]],
            weights:  [[2, 3, 4], [5, 6, 7], [8, 9, 10]]
          },
          %{
            biases:   [[5, 6]],
            weights:  [[2, 3], [4, 5], [6, 7]]
          },
          %{
            biases:   [[7, 8]],
            weights:  [[2, 3], [4, 5]]
          }
        ]
      }
    }

    {:ok, setup: %{
      first_network_state:  first_network_state,
      path:                 path,
      second_network_state: second_network_state,
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
