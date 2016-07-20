defmodule StateTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.State

  setup do
    network_parameters = %{
      layers: %{
        input:  %{size: 1},
        hidden: [
          %{
            activity: :identity,
            name:     "First Hidden",
            size:     1
          }
        ],
        output: %{
          activity: :identity,
          name:     "Output",
          size:     1
        }
      },
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    network = State.start(network_parameters)

    {:ok, setup: %{network: network}}
  end

  test "#start returns a running process", %{setup: setup} do
    %{network: network} = setup

    assert network |> is_pid
    assert Process.alive?(network)
  end

  test "#get_state returns the state", %{setup: setup} do
    %{network: network} = setup

    result   = State.get_state(network)

    assert result |> is_map
  end
end

