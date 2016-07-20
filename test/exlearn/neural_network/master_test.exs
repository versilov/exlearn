defmodule MasterTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Master

  test "#start returns a running process" do
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

    network = Master.start(network_parameters)

    assert network |> is_pid
    assert Process.alive?(network)
  end
end
