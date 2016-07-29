defmodule WorkerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.{Logger, Store, Worker}

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
    worker_name = {:global, make_ref()}

    {:ok, _logger} = Logger.start([], [name: logger_name])

    names_for_state = %{logger_name: logger_name}
    state_args      = {network_parameters, names_for_state}
    state_options   = [name: state_name]

    {:ok, _state} = Store.start(state_args, state_options)

    batch         = [{1, 1}, {2, 2}]
    configuration = %{configuration: :configuration}
    network_state = %{network_state: :network_state}

    worker_args    = %{logger_name: logger_name, state_name: state_name}
    worker_options = [name: worker_name]

    {:ok, worker} = Worker.start(worker_args, worker_options)

    {:ok, setup: %{
      batch:         batch,
      configuration: configuration,
      name:          worker_name,
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
      name:   {:global, reference},
      worker: worker
    } = setup

    assert reference |> is_reference
    assert worker    |> Process.alive?
  end
end
