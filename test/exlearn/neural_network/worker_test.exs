defmodule WorkerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.{State, Worker}

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

    state_name = {:global, make_ref()}

    {:ok, state} = State.start(network_parameters, name: state_name)

    batch         = [{1, 1}, {2, 2}]
    configuration = %{configuration: :configuration}
    network_state = %{network_state: :network_state}

    name = {:global, make_ref()}

    args    = %{state_name: state_name}
    options = [name: name]

    {:ok, worker} = Worker.start(args, options)

    {:ok, setup: %{
      batch:         batch,
      configuration: configuration,
      name:          name,
      network_state: network_state,
      worker:        worker
    }}
  end

  test "#set_batch receives success", %{setup: setup} do
    %{
      batch:  batch,
      name:   name,
      worker: worker
    } = setup

    expected = :ok
    result   = Worker.set_batch(batch, name)

    assert expected == result
    assert worker |> Process.alive?
  end

  test "#set_configuration receives success", %{setup: setup} do
    %{
      configuration: configuration,
      name:          name,
      worker:        worker
    } = setup

    expected = :ok
    result   = Worker.set_configuration(configuration, name)

    assert expected == result
    assert worker |> Process.alive?
  end

  test "#set_network_state receives success", %{setup: setup} do
    %{
      network_state: network_state,
      name:          name,
      worker:        worker
    } = setup

    expected = :ok
    result   = Worker.set_network_state(network_state, name)

    assert expected == result
    assert worker |> Process.alive?
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      name:   name = {:global, reference},
      worker: worker
    } = setup

    assert reference |> is_reference
    assert worker    |> Process.alive?
  end
end
