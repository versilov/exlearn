defmodule BuilderTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Builder

  setup do
    activity_function   = fn(x)       -> x + 1 end
    activity_derivative = fn(_)       -> 1     end
    objective_function  = fn(a, _, _) -> a     end
    objective_error     = fn(a, _)    -> a     end

    initialization_parameters = %{
      distribution: :uniform,
      range:        {-1, 1}
    }

    structure_parameters = %{
      layers: %{
        input:  %{size: 20},
        hidden: [
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            name: "First Hidden",
            size: 3
          },
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            name: "Second Hidden",
            size: 4
          }
        ],
        output: %{
          activity: %{
            function:   activity_function,
            derivative: activity_derivative
          },
          name: "Output",
          size: 5
        }
      },
      objective: %{
        function: objective_function,
        error:    objective_error
      },
    }

    {:ok, setup: %{
      activity_function:         activity_function,
      activity_derivative:       activity_derivative,
      initialization_parameters: initialization_parameters,
      objective_function:        objective_function,
      objective_error:           objective_error,
      structure_parameters:      structure_parameters
    }}
  end

  test "#create returns the uninitialized network state", %{setup: setup} do
    %{
      activity_function:    activity_function,
      activity_derivative:  activity_derivative,
      objective_function:   objective_function,
      objective_error:      objective_error,
      structure_parameters: structure_parameters
    } = setup

    expected = %{
      network: %{
        layers: [
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            biases:  :not_initialized,
            columns: 3,
            name:    "First Hidden",
            rows:    20,
            weights: :not_initialized
          },
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            biases:  :not_initialized,
            columns: 3,
            name:    "Second Hidden",
            rows:    4,
            weights: :not_initialized
          },
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            biases:  :not_initialized,
            columns: 4,
            name:    "Output",
            rows:    5,
            weights: :not_initialized
          }
        ],
        objective: %{
          function: objective_function,
          error:    objective_error
        }
      },
      structure: structure_parameters
    }

    assert Builder.create(structure_parameters) == expected
  end

  test "#initialize return a map", %{setup: setup} do
    %{
      initialization_parameters: initialization_parameters,
      structure_parameters:      structure_parameters
    } = setup

    network_state = Builder.create(structure_parameters)
    result        = Builder.initialize(initialization_parameters, network_state)

    assert result |> is_map

    %{network: %{layers: layers}} = result
    assert length(layers) == 5
  end
end
