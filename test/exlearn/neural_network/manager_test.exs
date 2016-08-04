defmodule ManagerTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Manager

  setup do
    name    = {:global, make_ref()}
    args    = []
    options = [name: name]

    {:ok, setup: %{
      args:    args,
      name:    name,
      options: options
    }}
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, worker_pid} = Manager.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert worker_pid |> is_pid
    assert worker_pid |> Process.alive?
    assert reference  |> is_reference
    assert worker_pid == pid_of_reference
  end
end
