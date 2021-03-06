defmodule MasterTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Master

  setup do
    children_names = %{
      accumulator:  {:global, make_ref()},
      manager:      {:global, make_ref()},
      notification: {:global, make_ref()},
      store:        {:global, make_ref()}
    }

    name    = {:global, make_ref()}
    args    = children_names
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
      name:    {:global, master_reference},
      options: options
    } = setup

    {:ok, master_pid}       = Master.start_link(args, options)
    pid_of_master_reference = :global.whereis_name(master_reference)

    assert master_pid       |> is_pid
    assert master_pid       |> Process.alive?
    assert master_reference |> is_reference
    assert master_pid == pid_of_master_reference
  end
end
