defmodule ExLearn.NeuralNetwork.Worker.GetTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  setup do
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      name:          name,
      options:       options,
    }}
  end

  test "#get with empty state returns the result", %{setup: setup} do
    %{
      name:    worker = {:global, reference},
      options: options
    } = setup

    args              = []
    {:ok, worker_pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end


  test "#get with empty data returns the result", %{setup: setup} do
    %{
      name:    worker = {:global, reference},
      options: options
    } = setup

    args = %{
      data: %{
        training:   %{location: :file,   source: []},
        validation: %{location: :memory, source: []},
        test:       %{location: :file,   source: []},
        ask:        %{location: :memory, source: []}
      }
    }

    {:ok, worker_pid} = Worker.start_link(args, options)

    assert Worker.get(worker) == :no_data

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end

  # TODO: get after training, validation, test, ask
end
