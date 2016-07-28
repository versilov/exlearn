defmodule MasterTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Master

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

    master_name = {:global, make_ref()}
    child_names = %{
      logger_name: {:global, make_ref()},
      state_name:  {:global, make_ref()},
      worker_name: {:global, make_ref()}
    }

    args    = {network_parameters, child_names}
    options = [name: master_name]

    {:ok, master} = Master.start_link(args, options)

    {:ok, setup: %{
      master:      master,
      master_name: master_name,
      child_names: child_names
    }}
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      master:      master,
      master_name: {:global, master_reference},
    } = setup

    pid_of_master_reference = :global.whereis_name(master_reference)

    assert master           |> is_pid
    assert master           |> Process.alive?
    assert master_reference |> is_reference
    assert master == pid_of_master_reference
  end
end
