defmodule StateTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.{Notification, Store}

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

    logger_name = {:global, make_ref()}
    state_name  = {:global, make_ref()}

    {:ok, _logger} = Notification.start([], [name: logger_name])

    names   = %{logger_name: logger_name}
    args    = {network_parameters, names}
    options = [name: state_name]

    {:ok, network} = Store.start(args, options)

    {:ok, setup: %{
      name:    state_name,
      network: network
    }}
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      name:    {:global, reference},
      network: network
    } = setup

    pid_of_reference = :global.whereis_name(reference)

    assert network   |> is_pid
    assert network   |> Process.alive?
    assert reference |> is_reference
    assert network == pid_of_reference
  end

  test "#get_state returns the state", %{setup: setup} do
    %{
      name:    name,
      network: network
    } = setup

    result = Store.get_state(name)

    assert result  |> is_map
    assert network |> Process.alive?
  end
end

