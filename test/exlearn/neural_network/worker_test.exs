defmodule WorkerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.{Notification, Store, Worker}

  setup do
    configuration = %{configuration: :configuration}
    data          = [{[1], [1]}, {[2], [2]}]
    network_state = %{network_state: :network_state}

    name    = {:global, make_ref()}
    args    = %{data: data, configuration: configuration}
    options = [name: name]

    {:ok, worker} = Worker.start(args, options)

    {:ok, setup: %{
      configuration: configuration,
      data:          data,
      name:          name,
      network_state: network_state,
      worker:        worker
    }}
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
