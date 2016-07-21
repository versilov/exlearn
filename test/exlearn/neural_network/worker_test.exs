defmodule WorkerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  setup do
    batch         = [{1, 1}, {2, 2}]
    configuration = %{configuration: :configuration}
    network_state = %{network_state: :network_state}

    worker = Worker.start(batch, configuration, network_state)

    {:ok, setup: %{
      batch:         batch,
      configuration: configuration,
      network_state: network_state,
      worker:        worker
    }}
  end

  test "#set_batch receives success", %{setup: setup} do
    %{worker: worker}    = setup
    {:global, reference} = worker

    new_batch = [{3, 3}, {4, 4}]

    expected = :ok
    result   = Worker.set_batch(new_batch, worker)

    assert expected == result
    assert :global.whereis_name(reference) |> Process.alive?
  end

  test "#set_configuration receives success", %{setup: setup} do
    %{worker: worker}    = setup
    {:global, reference} = worker

    new_configuration = %{new_configuration: :new_configuration}

    expected = :ok
    result   = Worker.set_configuration(new_configuration, worker)

    assert expected == result
    assert :global.whereis_name(reference) |> Process.alive?
  end

  test "#set_network_state receives success", %{setup: setup} do
    %{worker: worker}    = setup
    {:global, reference} = worker

    new_network_state = %{new_network_state: :new_network_state}

    expected = :ok
    result   = Worker.set_network_state(new_network_state, worker)

    assert expected == result
    assert :global.whereis_name(reference) |> Process.alive?
  end

  test "#start returns a running process", %{setup: setup} do
    %{worker: worker}    = setup
    {:global, reference} = worker

    assert reference |> is_reference
    assert :global.whereis_name(reference) |> Process.alive?
  end
end
